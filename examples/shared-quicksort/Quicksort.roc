app "quicksort" packages { base: "./platform" } provides [ quicksort ] to base

quicksort : List I64 -> List I64
quicksort = \originalList -> helper originalList

helper : List I64 -> List I64
helper = \originalList ->

    quicksortHelp : List (Num a), I64, I64 -> List (Num a)
    quicksortHelp = \list, low, high ->
        if low < high then
            when partition low high list is
                Pair partitionIndex partitioned ->
                    partitioned
                        |> quicksortHelp low (partitionIndex - 1)
                        |> quicksortHelp (partitionIndex + 1) high
        else
            list


    swap : I64, I64, List a -> List a
    swap = \i, j, list ->
        when Pair (List.get list i) (List.get list j) is
            Pair (Ok atI) (Ok atJ) ->
                list
                    |> List.set i atJ
                    |> List.set j atI

            _ ->
                []

    partition : I64, I64, List (Num a) -> [ Pair I64 (List (Num a)) ]
    partition = \low, high, initialList ->
        when List.get initialList high is
            Ok pivot ->
                when partitionHelp (low - 1) low initialList high pivot is
                    Pair newI newList ->
                        Pair (newI + 1) (swap (newI + 1) high newList)

            Err _ ->
                Pair (low - 1) initialList


    partitionHelp : I64, I64, List (Num a), I64, (Num a) -> [ Pair I64 (List (Num a)) ]
    partitionHelp = \i, j, list, high, pivot ->
        if j < high then
            when List.get list j is
                Ok value ->
                    if value <= pivot then
                        partitionHelp (i + 1) (j + 1) (swap (i + 1) j list) high pivot
                    else
                        partitionHelp i (j + 1) list high pivot

                Err _ ->
                    Pair i list
        else
            Pair i list



    result = quicksortHelp originalList 0 (List.len originalList - 1)

    if List.len originalList > 3 then
        result
    else
        # Absolutely make the `originalList` Shared by using it again here
        # but this branch is not evaluated, so should not affect performance
        List.set originalList 0 (List.len originalList)
