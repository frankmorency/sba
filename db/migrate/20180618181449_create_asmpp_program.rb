class CreateAsmppProgram < ActiveRecord::Migration
  def change
    CertificateType::ASMPP.create!(name: 'asmpp', title: 'ASMPP')
    program = Program.create!(name: 'asmpp', title: 'ASMPP')
    Group.create!(name: 'asmpp', title: 'ASMPP', program: program)
  end
end
