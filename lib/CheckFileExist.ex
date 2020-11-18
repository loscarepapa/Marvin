import Printex

defmodule CheckFile do

  def existFile(exist, seconds) when exist == true do

    prints "\n -> Saved in #{seconds}s", :yellow
    Hound.end_session

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
end
