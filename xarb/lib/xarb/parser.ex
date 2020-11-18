defmodule Xarb.Parser do
  def parse_ingredients(string) do
    case String.length(string) do
      0 -> {:error, string}
      _ -> string
            |> String.split(["\n"])
            |> split_on_white_space()
            |> check_all_elements()
            |> remove_empty_elements()
            |> check_if_empty_list()
    end
  end

  defp check_if_empty_list(list) do
    case length(list) do
      0 -> {:error, []}
      _ -> {:ok, list}
    end
  end

  defp remove_empty_elements([]), do: []
  defp remove_empty_elements([head|tail]) do
    IO.inspect([head|tail])
    case check_if_map_is_empty(head) do
      true -> remove_empty_elements(tail)
      false -> [head|remove_empty_elements(tail)]
    end
  end

  defp check_if_map_is_empty(map) do
    if map != [] do
      case Kernel.map_size(map) do
        0 -> true
        _ -> false
      end
    else true
    end
  end

  defp split_on_white_space([]) do
    []
  end
  defp split_on_white_space([head|tail]) do
    [String.split(head)| split_on_white_space(tail)]
  end

  defp check_all_elements([]), do: []
  defp check_all_elements([head|tail]) do
    [check_element(head)| check_all_elements(tail)]
  end

  defp check_element([]), do: []
  defp check_element(list) do
    case length(list) do
      0  -> %{}
      1  -> list_elements_to_map(list)
      2  -> list_elements_to_map(list)
      _  -> list
        |> replace_until_head_is_number()
        |> check_for_measurement()
        |> list_elements_to_map()
    end
  end

  defp replace_until_head_is_number([]), do: []
  defp replace_until_head_is_number([head|tail]) do
    case Float.parse(head) do
      {x,"/" <> rest} -> case Float.parse(rest) do
                              {y,_}  -> [x / y|tail]
                              :error -> [x|tail]
                         end
      {x,_}           -> case List.first(tail) do
                           "-" -> ruhin_helper(x,tail)
                           _ -> [x|tail]
                         end
      :error          -> replace_until_head_is_number(tail)
    end
  end

  defp ruhin_helper(x, tail) do
    {_,temptail} = List.pop_at(tail, 0)
    {i,newtail} = List.pop_at(temptail, 0)
    case Float.parse(i) do
      {y,_}  -> [(x + y)/2|newtail]
      :error -> [x|tail]
    end
  end

  defp check_for_measurement([]), do: []
  defp check_for_measurement([head|tail]) do
    if !is_number(head) do
      case is_measurement?(head) do
          true  ->  if length(tail) > 1 do [head|[combine_strings_of_list(tail)]]
                    else [head|tail] end
          false ->  [combine_strings_of_list([head] ++ tail)]
      end
    else [head|check_for_measurement(tail)]
    end
  end

  defp is_measurement?(string, list \\ ["ml","cl","dl","l","kg","g","krm","tsk","msk","liten","stor","normal","st","kruka"])
  defp is_measurement?(string, [head]), do: String.equivalent?(string, head)
  defp is_measurement?(string, [head|tail]) do
    case String.equivalent?(string, head) do
      true  -> true
      false -> false != is_measurement?(string, tail)
    end
  end

  defp combine_strings_of_list([head]), do: head
  defp combine_strings_of_list([head|tail]) do
    head <> " " <> combine_strings_of_list(tail)
  end


  defp list_elements_to_map(list) do
    case length(list) do
      0 -> %{}
      1 -> %{"name" => List.first(list)}
      2 -> %{"amount" => List.first(list),"name" => List.last(list)}
      3 -> %{"amount" => List.first(list),"measurement" => List.first(List.delete_at(list,0)),"name" => List.last(list)}
    end
  end

end
