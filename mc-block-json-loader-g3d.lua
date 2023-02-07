-- written by Le Juez Victor to load Minecraft cube models in JSON format
-- February 2023
-- MIT license

local json = require("json")

local createVertex = function (pos,uv)
    local x,y,z = unpack(pos)
    local u,v = unpack(uv)
    return {x,y,z,u,v}
end

return function (path)
    local result = {}

    -- load the file
    local contents, size = love.filesystem.read(path)
    if contents == nil then
        error("Failed to load file: " .. path)
    end

    -- parse the json data
    local data = json.decode(contents)

    for i, element in ipairs(data.elements) do

        -- extract the vertex positions
        local from = element.from
        local to = element.to
        local positions = {
            {from[1], from[2], from[3]},        -- front-bottom-left
            {to[1], from[2], from[3]},          -- front-bottom-right
            {to[1], to[2], from[3]},            -- front-top-right
            {from[1], to[2], from[3]},          -- front-top-left
            {from[1], from[2], to[3]},          -- back-bottom-left
            {to[1], from[2], to[3]},            -- back-bottom-right
            {to[1], to[2], to[3]},              -- back-top-right
            {from[1], to[2], to[3]},            -- back-top-left
        }

        -- extract the UV coordinates
        local uvs = {
            {element.faces.north.uv[1], element.faces.north.uv[2]},   -- front-bottom-left
            {element.faces.north.uv[3], element.faces.north.uv[2]},   -- front-bottom-right
            {element.faces.north.uv[3], element.faces.north.uv[4]},   -- front-top-right
            {element.faces.north.uv[1], element.faces.north.uv[4]},   -- front-top-left
            {element.faces.south.uv[3], element.faces.south.uv[2]},   -- back-bottom-right
            {element.faces.south.uv[1], element.faces.south.uv[2]},   -- back-bottom-left
            {element.faces.south.uv[1], element.faces.south.uv[4]},   -- back-top-left
            {element.faces.south.uv[3], element.faces.south.uv[4]},   -- back-top-right
        }

        -- triangulate each face
        for face, faceData in pairs(element.faces) do
            if face == "north" then
                -- front face
                table.insert(result, createVertex(positions[1],uvs[1]))
                table.insert(result, createVertex(positions[2],uvs[2]))
                table.insert(result, createVertex(positions[3],uvs[3]))
                table.insert(result, createVertex(positions[3],uvs[3]))
                table.insert(result, createVertex(positions[4],uvs[4]))
                table.insert(result, createVertex(positions[1],uvs[1]))
            elseif face == "east" then
                -- right face
                table.insert(result, createVertex(positions[2],uvs[2]))
                table.insert(result, createVertex(positions[6],uvs[6]))
                table.insert(result, createVertex(positions[7],uvs[7]))
                table.insert(result, createVertex(positions[7],uvs[7]))
                table.insert(result, createVertex(positions[3],uvs[3]))
                table.insert(result, createVertex(positions[2],uvs[2]))
            elseif face == "south" then
                -- back face
                table.insert(result, createVertex(positions[6],uvs[6]))
                table.insert(result, createVertex(positions[5],uvs[5]))
                table.insert(result, createVertex(positions[8],uvs[8]))
                table.insert(result, createVertex(positions[8],uvs[8]))
                table.insert(result, createVertex(positions[7],uvs[7]))
                table.insert(result, createVertex(positions[6],uvs[6]))
            elseif face == "west" then
                -- left face
                table.insert(result, createVertex(positions[5],uvs[5]))
                table.insert(result, createVertex(positions[1],uvs[1]))
                table.insert(result, createVertex(positions[4],uvs[4]))
                table.insert(result, createVertex(positions[4],uvs[4]))
                table.insert(result, createVertex(positions[8],uvs[8]))
                table.insert(result, createVertex(positions[5],uvs[5]))
            elseif face == "up" then
                -- top face
                table.insert(result, createVertex(positions[4],uvs[4]))
                table.insert(result, createVertex(positions[3],uvs[3]))
                table.insert(result, createVertex(positions[7],uvs[7]))
                table.insert(result, createVertex(positions[7],uvs[7]))
                table.insert(result, createVertex(positions[8],uvs[8]))
                table.insert(result, createVertex(positions[4],uvs[4]))
            elseif face == "down" then
                -- bottom face
                table.insert(result, createVertex(positions[5],uvs[5]))
                table.insert(result, createVertex(positions[6],uvs[6]))
                table.insert(result, createVertex(positions[2],uvs[2]))
                table.insert(result, createVertex(positions[2],uvs[2]))
                table.insert(result, createVertex(positions[1],uvs[1]))
                table.insert(result, createVertex(positions[5],uvs[5]))
            end
        end
    end

    return result
end