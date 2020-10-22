Application.start :hound

defmodule Marvin do
  use Hound.Helpers

  def run do
    Hound.start_session

    navigate_to("https://agentes.qualitas.com.mx/cas/login?service=https%3A%2F%2Fagentes.qualitas.com.mx%2Fc%2Fportal%2Flogin")

    fill_field(find_element(:name, "agente"), "78069")

    fill_field(find_element(:name, "username"), "MAESTRA")

    fill_field(find_element(:name, "password"), "Brv099")

    find_element(:name, "submit") |> click() 

    navigate_to("https://agentes.qualitas.com.mx/group/guest/reportes")

    find_element(:css, "#select-report option[value='10']") |> click()

    execute_script("jQuery(this)._ReportQualitasPortlet_postWithExcel('https://agentes.qualitas.com.mx/group/guest/reportes/-/Report-Qualitas/xls/emitidas?p_p_lifecycle=2&p_p_resource_id=verExcelEmitida&p_p_cacheability=cacheLevelPage',{agent:'78069',month:'',year:'',date_from:'01/01/2012',date_to:'21/10/2020'});")

    File.rename("./../../../Downloads/poliza-emitida.xls", "./polizas/polizas.xls")

  end
end
