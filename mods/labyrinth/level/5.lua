story = 0

local S = minetest.get_translator("labyrinth")
local function init_level()
    local player = minetest.get_player_by_name("singleplayer")
    safe_clear(20, 20)
    width = 9
    height = 9

    --Copy to the map
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=-5,y=-5,z=-5}, {x=height+5,y=15,z=width+5})
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
    local fire = minetest.get_content_id("fire:basic_flame")
    local book = minetest.get_content_id("homedecor:book_red")

    minetest.set_timeofday(0.2)
    --player target coords
    center_x = math.floor((height+1)/2)
    center_z = math.floor((width+1)/2)

    --Set up the level itself        
    for x=-3,height+3 do --x
        for z=-3,width+3 do --z        
            data[a:index(x, 0, z)] = wall
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
 for y=0,8 do
        for z=-2,width+4 do
            data[a:index(-2, y, z)] = wall
            data[a:index(height+3, y, z)] = wall
        end
    end
    for x=-2,height+3 do
        for y=0,8 do
            data[a:index(x, y, -2)] = wall
            data[a:index(x, y, width+4)] = wall
	 data[a:index(x, y, width+1)] = wall
        end
    end 
    
data[a:index(2, 1, 2)] = desk
    data[a:index(2, 1, 3)] = desk
    data[a:index(center_x, 2, width)] = air    
    param2[a:index(2, 2, 3)] = minetest.dir_to_facedir({x=-1,y=0,z=0})
    data[a:index(4, 1, 12)] = chest
    data[a:index(center_x, 1, width)] = door  

    for y=1,1 do
        for x=2,height-1 do
            data[a:index(x, y, center_z)] = fire
        end
    end
    for y=1,1 do
        for x=2,height-1 do
            data[a:index(x, y, 6)] = fire
        end
    end
    for y=1,1 do
        for x=2,height-1 do
            data[a:index(x, y, 7)] = fire
        end
    end

    data[a:index(5, 1, 8)] = book
    local meta1 = minetest.get_meta({ x = 5, y = 1,z = 8 })
	meta1:set_string("title","level 1")
	meta1:set_string("text",S("超级隐藏房"))


    minetest.register_globalstep(
        function(dtime)
            if player then                
                local node = minetest.get_node(player:get_pos())                
                -- minetest.chat_send_all(dump(node))
                if node.name == "doors:door_steel_a" then
                    next_level()
                end

                local node2 = minetest.get_node({x=2,y=2,z=3})
                if story == 0 and node2.name == "laptop:portable_workstation_2_open_on" then
                    story = story + 1
                end


            end
        end
    )    

    vm:set_data(data)
    vm:set_param2_data(param2)
    vm:write_to_map(true) 
end

local function init_story() 

end

init_level()
init_story()


