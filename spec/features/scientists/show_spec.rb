require 'rails_helper'

RSpec.describe 'Scientists Show Page' do 
  before(:each) do 
    @lab1 = Lab.create!(name: "710labs")
    @lab2 = Lab.create!(name: "Dexter's Lab")

    @scientist1 = Scientist.create!(name: "Mike Jones", specialty: "Drank", university: "Houston", lab: @lab1)
    @scientist2 = Scientist.create!(name: "Sean Paul", specialty: "Dance", university: "South Harmon Institute of Tech", lab: @lab1)
    @scientist3 = Scientist.create!(name: "Bob Barker", specialty: "Price", university: "CU Boulder", lab: @lab1)
    @scientist4 = Scientist.create!(name: "Tom Hanks", specialty: "Love", university: "Alabama", lab: @lab2)
    
    @experiment1 = Experiment.create!(name: "Mentos and Diet Coke", objective: "Save the Planet", num_months: 420)
    @experiment2 = Experiment.create!(name: "Baking Soda Volcano", objective: "Educate children", num_months: 69)
    @experiment3 = Experiment.create!(name: "Project X", objective: "Party", num_months: 5)
    @experiment4 = Experiment.create!(name: "Wolverine", objective: "Make Claws", num_months: 7)
  
    ScientistExperiment.create!(experiment: @experiment1, scientist: @scientist1)
    ScientistExperiment.create!(experiment: @experiment1, scientist: @scientist2)
    ScientistExperiment.create!(experiment: @experiment2, scientist: @scientist3)
    ScientistExperiment.create!(experiment: @experiment3, scientist: @scientist4)
    ScientistExperiment.create!(experiment: @experiment4, scientist: @scientist1)
    
  end

  describe "scientists show page" do
    it "displays scientist's name, specialty, university; see name of lab where they work" do
      visit scientist_path(@scientist1)
      expect(page).to have_content("Name: Mike Jones")
      expect(page).to have_content("Specialty: Drank")
      expect(page).to have_content("University: Houston")
      expect(page).to have_content("Lab: 710labs")
      expect(page).to_not have_content("Name: Sean Paul")
      
      within("#experiments") do
        expect(page).to have_content("Experiments: Mentos and Diet Coke")
        expect(page).to have_content("Experiments: Wolverine")
      end
    end

    it "displays button to remove experiment; click button and brough back to show page; experiment no longer listed, but experiment should be displayed on other scientists page" do
      visit scientist_path(@scientist2)
      expect(page).to have_content("Name: Sean Paul")

      within("#experiments") do
        expect(page).to have_content("Experiments: Mentos and Diet Coke")
        expect(page).to have_button("Remove Experiment")

        click_button("Remove Experiment")
        expect(current_path).to eq(scientist_path(@scientist2))
        expect(page).to_not have_content("Experiments: Mentos and Diet Coke")
      end

      visit scientist_path(@scientist1)
      expect(page).to have_content("Experiments: Mentos and Diet Coke")
    end
  end
end