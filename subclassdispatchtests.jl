abstract AbstrType

type ConcrType1 <: AbstrType
    x::Int
end
f(a::ConcrType1) = a.x

type ConcrType2 <: AbstrType
    x::Int
end
f(a::ConcrType2) = a.x


function main()
    println()

    n = 100_000

    arrconcr = [ConcrType1(i) for i=1:n]
    arrabstr = AbstrType[iseven(i) ? ConcrType1(i) : ConcrType2(i) for i=1:n]


    @time for a in arrconcr; f(a); end

    @time for a in arrabstr; f(a); end


    # Yet another experiment
    @time for a in arrabstr
        T = typeof(a)
        if T === ConcrType1
            f(a::ConcrType1)
        elseif T === ConcrType2
            f(a::ConcrType2)
        else
            f(a)
        end
    end

end

main()
main()
