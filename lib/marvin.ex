Application.start :hound

defmodule Marvin do
  use Hound.Helpers


  def init(%{born: born, agente: agente, username: username, pass: pass}) do 

    login(agente, username, pass)
    getPolizas(born)
    moveXls()
  end

  def login(agente, username, pass) do 
    Hound.start_session

    navigate_to("https://agentes.qualitas.com.mx/cas/login?service=https%3A%2F%2Fagentes.qualitas.com.mx%2Fc%2Fportal%2Flogin")

    fill_field(find_element(:name, "agente"), "#{agente}")

    fill_field(find_element(:name, "username"), "#{username}")

    fill_field(find_element(:name, "password"), "#{pass}")

    find_element(:name, "submit") |> click() 

  end

  def getPolizas(born) do

    navigate_to("https://agentes.qualitas.com.mx/group/guest/reportes")

    execute_script("jQuery(this)._ReportQualitasPortlet_postWithExcel('https://agentes.qualitas.com.mx/group/guest/reportes/-/Report-Qualitas/xls/emitidas?p_p_lifecycle=2&p_p_resource_id=verExcelEmitida&p_p_cacheability=cacheLevelPage',{agent:'78069',month:'',year:'',date_from:'01/01/#{born}',date_to:'21/10/2020'});")

  end

  def moveXls do
    {:ok, download_path} = File.cwd()

    File.rename("./../../../Downloads/poliza-emitida.xls", "#{download_path}/polizas/polizas.xls")

  end

end
