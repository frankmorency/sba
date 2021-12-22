# sources
# https://docs.google.com/spreadsheets/d/125fBxCi8YqsoXMhgow4oTgbj3BR0lR606wHZPS2jGA0/edit#gid=0
# https://docs.google.com/spreadsheets/d/1-92jJtsdH-njYmMJ9E1ROYwINbfZGnCyfO41FPTxdkY/edit#gid=902488715
class LoadDutyStationsAndBuisnessUnits < ActiveRecord::Migration
  def change
    [["Connecticut",1],
    ["Maine",1],
    ["Massachusetts",1],
    ["N Hampshire",1],
    ["Rhode Island",1],
    ["Vermont",1],
    ["Buffalo",2],
    ["New Jersey",2],
    ["New York",2],
    ["PR & USVI",2],
    ["Syracuse",2],
    ["Baltimore",3],
    ["Delaware",3],
    ["Philadelphia",3],
    ["Pittsburgh",3],
    ["Richmond",3],
    ["Washington",3],
    ["West Virginia",3],
    ["Alabama",4],
    ["Georgia",4],
    ["Kentucky",4],
    ["Mississippi",4],
    ["N Carolina",4],
    ["N Florida",4],
    ["S Carolina",4],
    ["S Florida",4],
    ["Tennessee",4],
    ["Cleveland",5],
    ["Columbus",5],
    ["Illinois",5],
    ["Indiana",5],
    ["Michigan",5],
    ["Minnesota",5],
    ["Wisconsin",5],
    ["Arkansas",6],
    ["Dallas",6],
    ["El Paso",6],
    ["Houston",6],
    ["Louisiana",6],
    ["Lower Rio G V",6],
    ["Lubbock",6],
    ["New Mexico",6],
    ["Oklahoma",6],
    ["San Antonio",6],
    ["Des Moines",7],
    ["Kansas City",7],
    ["Nebraska",7],
    ["St. Louis",7],
    ["Wichita",7],
    ["Colorado",8],
    ["Montana",8],
    ["N Dakota",8],
    ["S Dakota",8],
    ["Utah",8],
    ["Wyoming",8],
    ["Arizona",9],
    ["Fresno",9],
    ["Hawaii",9],
    ['Los Angeles',9],
    ["Nevada",9],
    ["Sacramento",9],
    ["San Diego",9],
    ["San Francisco",9],
    ["Santa Ana",9],
    ["Alaska",10],
    ["Boise",10],
    ["Portland",10],
    ["Seattle",10]].each do |couple|
      DutyStation.create!(name: couple[0], region_code: couple[1])
    end

    ["CODS", "DO", "OFFICE", "AREA", "OFFICE", "OGC", "HQ", "HQ_CE", "HQ_Legal", "HQ_program", "HQ_AA", "DO"].each do |n|
      BusinessUnit.create!(name: n)
    end 

  end
end