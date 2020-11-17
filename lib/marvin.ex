Application.start :hound
import Printex
import CheckFile

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
    :timer.sleep(1000)

  end

  def getPolizas(born) do

    prints "\n -> Downloading file ...", :blue
    navigate_to("https://agentes.qualitas.com.mx/group/guest/reportes")
    execute_script("
             jQuery(this).
              _ReportQualitasPortlet_postWithExcel('https://agentes.qualitas.com.mx/" <> 
                "group/guest/reportes/-/Report-Qualitas/xls/" <> 
                  "emitidas?p_p_lifecycle=2&p_p_resource_id=verExcelEmitida&p_p_cacheability=cacheLevelPage',
      {
              agent:'78069',
              month:'',
              year:'',
              date_from:'01/01/#{born}',
              date_to:'21/10/2020'
      });"
    )
    CheckFile.existFile(false, 0)
    prints "\n -> Download successful!", :green
    :timer.sleep(1000)
    moveXls(File.cwd)

  end

def moveXls({:ok, dir}) do

  prints "\n -> Creating directory and moving file ...", :blue
  File.mkdir_p("./polizas")

  cond do

    File.read("./../../../Downloads/poliza-emitida.xls") != {:error, :enoent} ->
      File.rename("./../../../Downloads/poliza-emitida.xls", "#{dir}/polizas/polizas.xls")


    File.read("./../../Downloads/poliza-emitida.xls") != {:error, :enoent} ->
      File.rename("./../../Downloads/poliza-emitida.xls", "#{dir}/polizas/polizas.xls")


    :true == :true -> prints "\n -> The file no exist, please check the node in save!", :yellow

  end

  prints "\n -> Moved successful!", :green
  :timer.sleep(1000)

end

def endSessionWeb(fileTo) do
  [{:ok, pid1, parser1}, {:ok, _, _}, {:ok, _, _}] = Exoffice.parse(fileTo)
  stream = Exoffice.count_rows(pid1, parser1)
  IO.puts stream
    #Hound.end_session()
end

end
