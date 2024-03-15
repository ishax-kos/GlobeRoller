extends Node
class_name Save


#class Lookup:
    #var entries: int
    #var buffer: PackedByteArray

static func create_string_lookup(table: Array[String]) -> PackedByteArray:
    var offsets: PackedInt32Array
    var output_data: PackedByteArray
    offsets.resize(table.size()+1)
    var len := offsets.size()*4
    for s in table.size():
        var buffer := table[s].to_utf8_buffer()
        offsets[s] = len
        output_data.append_array(buffer)
        len += buffer.size()
    offsets[-1] = len
    return offsets.to_byte_array() + output_data



static func create_texture_lookup(table: Array[Texture2D]) -> PackedByteArray:
    var meta_data: PackedByteArray
    var image_data: PackedByteArray
    const meta_data_size = 14
    meta_data.resize(meta_data_size*table.size()+4)
    var data_offset := meta_data.size()
    for tex in table.size():
        var meta_data_offset = meta_data_size*tex
        var image :Image= table[tex].get_image()
        if image.is_compressed():
            image.decompress()
        var buffer := image.get_data()
        print("size: ", buffer.size())
        meta_data.encode_u32(meta_data_offset+0, data_offset)
        meta_data.encode_u32(meta_data_offset+4, buffer.size())
        meta_data.encode_u16(meta_data_offset+8, image.get_width())
        meta_data.encode_u16(meta_data_offset+10, image.get_height())
        meta_data.encode_u16(meta_data_offset+12, image.get_format())
        
        buffer = buffer.compress(FileAccess.COMPRESSION_ZSTD)
        
        image_data.append_array(buffer)
        data_offset += buffer.size()
    meta_data.encode_u32(meta_data_size*table.size(), data_offset)
    return meta_data + image_data


static func fetch_texture(lookup: PackedByteArray, index: int) -> Texture2D:
    const meta_data_size := 14
    var offset := index*meta_data_size
    var start := lookup.decode_u32(offset)
    var stop := lookup.decode_u32(offset+meta_data_size)
    var output_size := lookup.decode_u32(offset+4)
    var size := Vector2i(
        lookup.decode_u16(offset+8),
        lookup.decode_u16(offset+10)
    )
    print("size: ", output_size)
    var format := lookup.decode_u16(offset+12)
    var data := lookup\
        .slice(start, stop)\
        .decompress(output_size, FileAccess.COMPRESSION_ZSTD)
    print("start stop: $%08x, $%08x" % [start, stop])
    var image := Image.create_from_data(
        size.x, size.y, false, format, data)
    if image.is_empty(): print("invalid image")
    return ImageTexture.create_from_image(image)
    
    
static func fetch_string(lookup: PackedByteArray, index: int) -> String:
    #var offsets = lookup.to_int32_array()
    return lookup.slice(
        lookup.decode_u32(index*4), lookup.decode_u32((index+1)*4))\
        .get_string_from_utf8()


static func save_v3_0_0(continents: Array[Continent]) -> PackedByteArray:
    print("...")
    const format_version := 0
    #var properties :Array[String]= [
        #"name",
        #"projection",
        #"texture",
#
        #"latitude",
        #"longitude",
        #"rotation",
#
        #"image_offset",
        #"image_rotation",
        #"scale",
    #]
    #file.store_csv_line(properties)
    var textures : Array[Texture2D]
    var strings : Array[String]
    var continent_blocks : PackedByteArray
    for cont in continents:
        ## Name 
        var entry := cont.name.to_utf8_buffer()
        entry.resize(8+4+4+4+12+12+4)
        var s := cont.name
        var index = strings.find(s)
        if index == -1:
            index = strings.size()
            strings.append(s)
        entry.encode_u16(8, index)
        
        ## Projection
        s = Continent.Projection_type.find_key(cont.projection)
        index = strings.find(s)
        if index == -1:
            index = strings.size()
            strings.append(s)
        entry.encode_u32(12, index)
        
        ## Textures
        entry.encode_u32(16, textures.size())
        textures.append(cont.texture)
        
        
        entry.encode_float(20, cont.latitude)
        entry.encode_float(24, cont.longitude)
        entry.encode_float(28, cont.rotation)
        
        entry.encode_float(32, cont.image_offset.x)
        entry.encode_float(36, cont.image_offset.y)
        entry.encode_float(40, cont.image_rotation)
        
        entry.encode_float(44, cont.scale)
        
        continent_blocks.append_array(entry)

    var string_lookup := create_string_lookup(strings)
    var texture_lookup := create_texture_lookup(textures)

    var buffer := "GlobeRoller3".to_utf8_buffer()
    buffer.resize(48)
    buffer.encode_u32(12, format_version)
    var advance := buffer.size()
    
    ## Continents
    buffer.encode_u32(16, continents.size())
    advance += continent_blocks.size() 
    
    ## String Lookup
    buffer.encode_u32(20, advance)
    buffer.encode_u32(24, string_lookup.size())
    buffer.encode_u32(28, strings.size())
    advance += string_lookup.size() 
    
    ## Texture Lookup
    buffer.encode_u32(32, advance)
    buffer.encode_u32(36, texture_lookup.size())
    buffer.encode_u32(40, textures.size())
    advance += texture_lookup.size() 
    
    
    return buffer+continent_blocks+string_lookup+texture_lookup
    

static func load_v3_0_0(buffer: PackedByteArray) -> Array[Continent]:
    var continent_count := buffer.decode_u32(16)
    var strings_offset := buffer.decode_u32(20)
    var strings_size := buffer.decode_u32(24)
    var string_count := buffer.decode_u32(28)
    var textures_offset := buffer.decode_u32(32)
    var textures_size := buffer.decode_u32(36)
    var texture_count := buffer.decode_u32(40)
    
    var strings := buffer.slice(
        strings_offset, strings_offset+strings_size)
    
    var textures := buffer.slice(
        textures_offset, textures_offset+textures_size)
    
    var continents : Array[Continent]
    
    const continent_size := 48
    const header_size := 48
    
    for c in continent_count:
        var cont := Continent.new()
        var cont_buffer := buffer.slice(header_size+c*continent_size)
        var sample_string := cont_buffer.slice(0, 8).get_string_from_utf8()
        print("|%s|" % sample_string)
        cont.name = fetch_string(strings, cont_buffer.decode_u16(8))
        
        var projection_name := fetch_string(strings, cont_buffer.decode_u16(12))
        cont.projection = Continent.Projection_type.get(projection_name, 0)
        cont.texture = fetch_texture(textures, cont_buffer.decode_u16(16))
        if !cont.texture: 
            print_debug("invalid_texture_data")
            cont.texture = preload("res://maps/azimuth.png")
            #continue
        
        cont.latitude  = cont_buffer.decode_float(20)
        cont.longitude = cont_buffer.decode_float(24)
        cont.rotation  = cont_buffer.decode_float(28)
        
        cont.image_offset.x = cont_buffer.decode_float(32)
        cont.image_offset.y = cont_buffer.decode_float(36) 
        cont.image_rotation = cont_buffer.decode_float(40)
        
        cont.scale = cont_buffer.decode_float(44)
        
        continents.append(cont)
    return continents
