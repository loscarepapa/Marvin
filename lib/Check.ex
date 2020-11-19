import Printex

defmodule Check do

  def existFile(exist, seconds) when exist == true do

    prints "\n -> Saved in #{seconds}s", :yellow

  end

  def existFile(_, seconds) when seconds >= 30 do

    prints "\n -> It takes too long to load", :red

  end

  def existFile(exist, seconds) do

    :timer.sleep(1000)

    if File.exists?("./../../../Downloads/tablePolizaEmitida.csv") || 
      File.exists?("./../../Downloads/tablePolizaEmitida.csv") do
      existFile(true, seconds)
    else
      existFile(exist, seconds + 1)
    end
  end

  def existTable(exist, seconds) when exist == true do

    prints "\n -> Table exist in #{seconds}s", :yellow

  end

  def existTable(exist, seconds) do

    use Hound.Helpers
    :timer.sleep(1000)

    if match?({:ok, _}, search_element(:id, "tablePolizaEmitida")) && 
      match?({:ok, _}, search_element(:name, "tablePolizaEmitida_length")) do
      existTable(true, seconds)
    else
      existTable(exist, seconds + 1)
    end
  end

end
