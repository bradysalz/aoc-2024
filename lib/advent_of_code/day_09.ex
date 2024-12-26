defmodule AdventOfCode.Day09 do
  defmodule Block do
    defstruct [
      :file_id,
      is_free: false,
      # is this item the start of a file block?
      is_file_start: false,
      # if either of ^^, how long is the block?
      block_len: nil
    ]
  end

  def log_disk(disk) do
    disk
    |> Enum.each(fn block ->
      cond do
        block.is_free ->
          IO.write(".")

        true ->
          IO.write(block.file_id)
      end
    end)

    IO.puts("")
    disk
  end

  def map_disk(inputs) do
    {lst, _, _} =
      Enum.reduce(inputs, {[], :file, 0}, fn val, acc ->
        {lst, ftype, file_id} = acc

        lst =
          if val > 0 do
            Enum.reduce(1..val, lst, fn idx, acc ->
              case {idx, ftype} do
                {1, :file} ->
                  [%Block{file_id: file_id, is_file_start: true, block_len: val}] ++ acc

                {_, :file} ->
                  [%Block{file_id: file_id}] ++ acc

                {_, :space} ->
                  [%Block{is_free: true}] ++ acc
              end
            end)
          else
            # any range definition will be at least len==1
            lst
          end

        case ftype do
          :file ->
            {lst, :space, file_id}

          :space ->
            {lst, :file, file_id + 1}
        end
      end)

    lst
    |> Enum.reverse()
  end

  def sort_disk(disk) do
    # parse until rev index <= fwd index
    disk_with_index = Enum.with_index(disk)

    spaces_with_index =
      Enum.filter(disk_with_index, fn {block, _idx} ->
        block.is_free
      end)

    reverse_file_with_index =
      Enum.reverse(disk_with_index)
      |> Enum.reject(fn {block, _idx} ->
        block.is_free
      end)

    pairs = Enum.zip(spaces_with_index, reverse_file_with_index)

    Enum.reduce_while(pairs, disk, fn pair, acc ->
      {{free_block, free_idx}, {file_block, file_idx}} = pair

      if file_idx <= free_idx do
        {:halt, acc}
      else
        disk = List.update_at(acc, free_idx, fn _ -> file_block end)
        disk = List.update_at(disk, file_idx, fn _ -> free_block end)
        {:cont, disk}
      end
    end)
  end

  @doc """
  Given a disk array, return an array {idx_start, size_free} tuples
  """
  def find_all_gaps(disk) do
    {blocks, _, _} =
      disk
      |> Enum.with_index()
      |> Enum.reduce({[], nil, 0}, fn
        {block, index}, {acc, free_block_start, length} ->
          if block.file_id == nil do
            if free_block_start == nil do
              {acc, index, 1}
            else
              {acc, free_block_start, length + 1}
            end
          else
            if free_block_start == nil do
              {acc, nil, 0}
            else
              {[{free_block_start, length} | acc], nil, 0}
            end
          end
      end)

    blocks
    |> Enum.reverse()
  end

  def defrag_disk(disk) do
    IO.puts("#######")

    file_slots =
      disk
      |> Enum.with_index()
      |> Enum.filter(fn {block, _} -> block.is_file_start end)
      |> Enum.reverse()

    Enum.reduce(file_slots, disk, fn file_block, acc ->
      log_disk(acc)

      gap_found =
        find_all_gaps(acc)
        |> found_gap_for_file?(file_block)

      if gap_found != nil do
        swap_blocks(acc, gap_found, file_block)
      else
        acc
      end
    end)
  end

  def swap_blocks(disk, gap, file) do
    {block, block_idx} = file

    disk =
      Enum.reduce(0..(block.block_len - 1), disk, fn idx, acc ->
        List.replace_at(acc, idx + block_idx, %Block{is_free: true})
      end)

    Enum.reduce(0..(block.block_len - 1), disk, fn idx, acc ->
      List.replace_at(acc, idx + gap, %Block{file_id: block.file_id})
    end)
  end

  def found_gap_for_file?(gaps, _) when length(gaps) == 0, do: nil

  def found_gap_for_file?(gaps, file_block) do
    [{gap_start, gap_length} | rest_of_gaps] = gaps

    {block, block_start} = file_block

    if gap_length >= block.block_len do
      gap_start
    else
      # don't keep looking if we've hit all slots
      if gap_start > block_start do
        nil
      else
        found_gap_for_file?(rest_of_gaps, file_block)
      end
    end
  end

  def calculate_checksum(disk) do
    disk
    |> Enum.with_index()
    |> Enum.map(fn {block, idx} ->
      if block.is_free do
        0
      else
        idx * block.file_id
      end
    end)
    |> Enum.sum()
  end

  def part1(filepath) do
    filepath
    |> File.read!()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> map_disk()
    |> sort_disk()
    |> calculate_checksum()
  end

  def part2(filepath) do
    filepath
    |> File.read!()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> map_disk()
    |> IO.inspect()
    |> defrag_disk()
    |> calculate_checksum()
  end
end
