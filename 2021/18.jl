function tokenize(input)
    map(collect(input)) do c
        if c == '['
            return :open
        elseif c == ']'
            return :close
        elseif c == ','
            return :comma
        else
            return parse(Int, c)
        end
    end
end

function add(t1, t2)
    tokens = [:open; t1; :comma; t2; :close]
    reduction(tokens)
end

function addlast(tokens, amount;)
    iter = enumerate(tokens)
    for (i, t) in Iterators.reverse(enumerate(tokens))
        if isa(t, Int)
            tokens[i] += amount
            return tokens
        end
    end
    tokens
end

function addfirst(tokens, amount)
    for (i, t) in enumerate(tokens)
        if isa(t, Int)
            tokens[i] += amount
            return tokens
        end
    end
    tokens
end


function explode(tokens)
    depth = 0
    for (i, t) in enumerate(tokens)
        if t == :open
            depth += 1
        elseif t == :close
            depth -= 1
        elseif isa(t, Int) && depth == 5 && i + 3 ≤ length(tokens) && isa(tokens[i+2], Int)
            left = addlast(tokens[begin:i-2], t)
            right = addfirst(tokens[i+4:end], tokens[i+2])
            tokens = [left; 0; right]
            return tokens, true
        end
    end

    tokens, false
end

function splitt(tokens)
    for (i, t) in enumerate(tokens)
        if isa(t, Int) && t ≥ 10
            left = tokens[begin:i-1]
            right = tokens[i+1:end]
            tokens = [left; :open; fld(t, 2); :comma; cld(t, 2); :close; right]
            return tokens, true
        end
    end
    return tokens, false
end

function reduction(tokens)
    while true
        tokens, exploded = explode(tokens)

        if exploded
            continue
        end

        tokens, splitted = splitt(tokens)
        if splitted
            continue
        end

        return tokens
    end
end

function magnitude(n)
    function mag(tokens)
        @assert tokens[1] == :open

        local left, right
        if tokens[2] == :open
            left, tokens = mag(tokens[2:end])
            @assert tokens[1] == :comma
            tokens = tokens[2:end]
        else
            left = tokens[2]
            @assert tokens[3] == :comma
            tokens = tokens[4:end]
        end

        if tokens[1] == :open
            right, tokens = mag(tokens)
        else
            right = tokens[1]
            tokens = tokens[2:end]
        end

        @assert tokens[1] == :close

        return 3 * left + 2 * right, tokens[2:end]
    end

    result, remaining = mag(n)
    @assert isempty(remaining)
    return result

end

function part1(inputs)
    total = reduce(add, inputs)
    return magnitude(total)
end

function part2(inputs)
    largest = 0

    for (i, a) in enumerate(inputs), (j, b) in enumerate(inputs)
        if i == j
            continue
        end

        total = add(a, b)
        largest = max(magnitude(total), largest)
    end

    largest
end

inputs = [tokenize(line) for line in eachline("18.txt")]

println("Part 1: ", part1(inputs))
println("Part 2: ", part2(inputs))
