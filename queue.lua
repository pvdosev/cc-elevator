Queue = {}

function Queue.new ()
  return {first = 0, last = -1}
end

function Queue.push (queue, value)
    local last = queue.last + 1
    queue.last = last
    queue[last] = value
end
  
function Queue.pop (queue)
    local first = queue.first
    if first > queue.last then error("queue is empty") end
    local value = queue[first]

    -- set to nil for gc to work
    queue[first] = nil
    queue.first = first + 1
    return value
end

function Queue.is_empty (queue)
    return queue.first > queue.last
end

function Queue.print (queue)
    io.write("\n(")
    for i=queue.first,queue.last do
        io.write(tostring(queue[i]), ", ")
    end
    io.write(")\n")
end

return Queue
