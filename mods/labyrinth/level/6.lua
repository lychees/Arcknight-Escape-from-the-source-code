function init_level()
    local player = minetest.get_player_by_name("singleplayer")
    safe_clear(10, 10)
    width = 9
    height = 9

    --Copy to the map
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=0,y=0,z=0}, {x=height*2,y=20,z=width*2})
    local data = vm:get_data()
    local param2 = vm:get_param2_data()
    local a = VoxelArea:new{
        MinEdge = emin,
        MaxEdge = emax
    }
    local wall = minetest.get_content_id("default:silver_sandstone_block")
    local air = minetest.get_content_id("air")
    local computer = minetest.get_content_id("laptop:portable_workstation_2_closed")
    local glass = minetest.get_content_id("xpanes:obsidian_pane_flat")
    local door = minetest.get_content_id("doors:door_steel_a")
    local desk = minetest.get_content_id("homedecor:table_mahogany")
    local chest = minetest.get_content_id("default:chest")
    local book = minetest.get_content_id("homedecor:book_red")

    --player target coords
    center_x = math.floor((height+1)/2)
    center_z = math.floor((width+1)/2)
    --player:set_pos({x=center_x,y=1.5,z=center_z-3})

    --Set up the level itself        
    for x=1,height do --x
        for z=1,width do --z        
            data[a:index(x, 0, z)] = wall
        end
    end      
    for x=1,height do --x
        for z=1,width do --z        
            data[a:index(x, 15, z)] = wall
        end
    end   
   
 for y=0,8 do
        for z=1,width do
            data[a:index(1, y, z)] = wall
            data[a:index(height, y, z)] = wall
        end
    end
 
   for x=1,height do
        for y=0,8 do
            data[a:index(x, y, 1)] = wall
            data[a:index(x, y, width)] = wall
        end
    end 

    data[a:index(2, 1, 2)] = desk
    data[a:index(2, 1, 3)] = desk  
    -- param2[a:index(center_x-3, 2, center_z-2)] = minetest.dir_to_facedir({x=-1,y=0,z=0})

    data[a:index(center_x, 1, width)] = door
    data[a:index(center_x, 2, width)] = air
    data[a:index(center_x, 16, width)] = chest
    data[a:index(5, 1, 6)] = book
    local meta1 = minetest.get_meta({ x = 5, y = 1,z = 6 })
	meta1:set_string("title","exit")
	meta1:set_string("text","对不起博士，我们的计划失败了，一切还是来\n的太迟了。在阻止切尔诺伯格核心城失败后，\n我们没能保护您。现在整合运动的意识读取计\n划已经完成，只希望我留下的这段文字您能够\n看到。炎国与乌萨斯的战争已经打响了，整合\n运动借此控制了大部分的地区，罗德岛的大家\n也不得不因此四处逃亡。但我知道一切还有转\n机。博士，还有真正的博士，希望您能在另一\n个世界拯救我们。——阿米娅留")

    minetest.register_globalstep(
        function(dtime)
            if player then                
                local node = minetest.get_node(player:get_pos())                
                if string.find(node.name, "door") == 1 then
                    next_level()
                end           
            end
        end
    )    

    vm:set_data(data)
    vm:set_param2_data(param2)
    vm:write_to_map(true)

    draw()
end

init_level()


