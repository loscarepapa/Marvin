Application.start :hound
import Printex

defmodule Marvin do

  use Hound.Helpers

  # File where save credentials and dates of agent
  @fileName "./config/credentials.json"

  def getAgente(file) do
    with {:ok, body} <- File.read(file),
         {:ok, json} <- Poison.decode(body), do:  {:ok, json}
    end

  def start do 

    {:ok, [
      %{
        "born" => born, 
        "agente" => agente, 
        "username" => username, 
        "pass" => pass
      }
    ]} = getAgente(@fileName) 

    #login in Qualitas
    login(agente, username, pass)

    #inject script 
    getPolizas(born)

  end

  def login(agente, username, pass) do 

    prints "\n -> Logging ...", :blue
    Hound.start_session
    navigate_to("https://agentes.qualitas.com.mx/cas/login?service=https%3A%2F%2Fagentes.qualitas.com.mx%2Fc%2Fportal%2Flogin")
    fill_field(find_element(:name, "agente"), "#{agente}")
    fill_field(find_element(:name, "username"), "#{username}")
    fill_field(find_element(:name, "password"), "#{pass}")
    find_element(:name, "submit") |> click() 
    prints "\n -> Login successful!", :green

    #IO.puts match?({:ok, _}, search_element(:id, "tablePolizaEmitida"))
  end

  def getPolizas(born) do

    {{year, mounth, day}, _} = :calendar.universal_time()

    prints "\n -> Generating table ...", :blue
    navigate_to("https://agentes.qualitas.com.mx/group/guest/reportes")
    execute_script("
            var select = document.querySelector('#select-report');
            select.value = 10;
            var father = select.parentNode;
            father.children[2].setAttribute('id', 'load-panel-reporte');
      "
    )
    find_element(:id, "load-panel-reporte") |> click()
    find_element(:name, "param") |> click()
    execute_script("
            var param = document.querySelector('.select-param');
            param.children[1].children[0].setAttribute('id','rangeOfDate')
      "
    )
    find_element(:id, "rangeOfDate") |> click()
    execute_script("
      $('#from').val('#{born}')
      $('#to').val('#{day}/#{mounth}/#{year}')
      "
    )
    find_element(:name, "accept") |> click()
    Check.existTable(false, 0)
   execute_script("
      document.querySelector('#tablePolizaEmitida_length').children[0].setAttribute('id', 'select_pagination')
      document.querySelector('#select_pagination').children[2].value = 5000
        "
      )
      find_element(:css, "#select_pagination option[value='5000']")
      |> click

      download()

    prints "\n -> Table generated successful!", :green

    Hound.end_session

    #IO.puts match?({:ok, _}, search_element(:id, "tablePolizaEmitida"))
  end

  def download() do

    prints "\n -> Downloading file ...", :blue
    {:ok, script} = File.read("./lib/createCsv.js")
    execute_script(script)
    Check.existFile(false, 0)
    moveFile(File.cwd)

  end 

  def moveFile({:ok, dir}) do
    prints "\n -> Creating directory and moving file ...", :blue
    File.mkdir_p("./polizas")

    cond do

      File.read("./../../../Downloads/tablePolizaEmitida.csv") != {:error, :enoent} ->
        File.rename("./../../../Downloads/tablePolizaEmitida.csv", "#{dir}/polizas/polizas.csv")


      File.read("./../../Downloads/tablePolizaEmitida.csv") != {:error, :enoent} ->
        File.rename("./../../Downloads/tablePolizaEmitida.csv", "#{dir}/polizas/polizas.csv")

      :true == :true -> prints "\n -> The file no exist, please check the node in save!", :yellow

    end

    prints "\n -> Moved successful!", :green

  end

end


