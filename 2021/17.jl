input = read("17.txt", String)
(x1, x2, y1, y2) = ([parse(Int, m.match) for m in eachmatch(r"-?\d+", input)]...,)

part1() = sum(1:-y1-1)

function part2()
    n = 0

    for x in 1:x2, y in y1:-y1
        vx, vy = x, y
        px, py = 0, 0

        while px <= x2 && py >= y1
            if px in x1:x2 && py in y1:y2
                n += 1
                break
            end

            px += vx
            py += vy

            if vx > 0
                vx -= 1
            end
            vy -= 1
        end
    end

    n
end

println("Part 1: ", part1())
println("Part 2: ", part2())