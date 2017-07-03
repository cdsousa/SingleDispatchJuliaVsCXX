abstract type AbstrType end

struct ConcrType1 <: AbstrType
    x::Int
end
f(a::ConcrType1) = a.x

struct ConcrType2 <: AbstrType
    x::Int
end
f(a::ConcrType2) = a.x

const n = 100_000

const arrconcr = [ConcrType1(i) for i=1:n]
const arrabstr = AbstrType[rand(Bool) ? ConcrType1(i) : ConcrType2(i) for i=1:n]
const arrunion = Union{ConcrType1, ConcrType2}[rand(Bool) ? ConcrType1(i) : ConcrType2(i) for i=1:n]

g_arrconcr(i) = arrconcr[i]
g_arrabstr(i) = arrabstr[i]
g_arrunion(i) = arrunion[i]

function main()
    println()
    gc()

    sum_arrconcr = 0::Int
    @time for i=1:n
        @inbounds sum_arrconcr += f(g_arrconcr(i))
    end

    sum_arrabstr = 0::Int
    @time for i=1:n
        @inbounds sum_arrabstr += f(g_arrabstr(i))
    end

    # manual dispatch
    sum_arrabstr2 = 0::Int
    @time for i=1:n
        @inbounds a = g_arrabstr(i)
        T = typeof(a)
        if T === ConcrType1
            sum_arrabstr2 += f(a::ConcrType1)
        elseif T === ConcrType2
            sum_arrabstr2 += f(a::ConcrType2)
        else
            sum_arrabstr2 += f(a)
        end
    end

    sum_arrunion = 0::Int
    @time for i=1:n
        @inbounds sum_arrunion += f(g_arrunion(i))
    end

    @assert sum_arrconcr == sum_arrabstr == sum_arrabstr2 == sum_arrunion

    println("(sum=$sum_arrconcr)")
end

main()
main()
