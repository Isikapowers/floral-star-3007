require "rails_helper"

# Story 2 - Mechanic Show Page
#
# As a user,
# When I visit a mechanic show page
# I see their name, years of experience, and the names of rides they’re working on
# And I only see rides that are open
# And the rides are listed by thrill rating in descending order (most thrills first)

RSpec.describe "Mechanic Show Page" do
  before(:each) do
    @six_flags = AmusementPark.create!(name: "Six Flags", price_of_admission: 49)

    @jon = Mechanic.create!(name: "Jon Doe", years_experience: 8)
    @kara = Mechanic.create!(name: "Kara Smith", years_experience: 11)

    @roller = @six_flags.rides.create!(name: "Roller Coaster", thrill_rating: 9, open: true)
    @merry = @six_flags.rides.create!(name: "Merry Go Round", thrill_rating: 2, open: false)
    @hammer = @six_flags.rides.create!(name: "Hammer Hitter", thrill_rating: 3, open: true)

    MechanicRide.create!(mechanic: @jon, ride: @roller)
    MechanicRide.create!(mechanic: @jon, ride: @merry)
    MechanicRide.create!(mechanic: @jon, ride: @hammer)
  end

  describe "#Story 2" do
    it "displays the mechanic's name and years of experience"
      visit "/mechanics/#{@jon.id}"

      expect(page).to have_content(@jon.name)
      expect(page).to have_content(@jon.years_experience)
    end

    it "displays the names of the rides they're working on" do
      visit "/mechanics/#{@jon.id}"

      within("#worked_on_rides") do
        expect(page).to have_no_content(@roller.name)
        expect(page).to have_no_content(@hammer.name)
        expect(page).to have_content(@merry.name)
      end
    end

    it "displays only the rides that are open" do
      visit "/mechanics/#{@jon.id}"

      within("#opened_rides") do
        expect(page).to have_content(@roller.name)
        expect(page).to have_content(@hammer.name)
        expect(page).to have_no_content(@merry.name)
      end
    end

    it "displays the rides listed by thrill rating in descending order" do
      visit "/mechanics/#{@jon.id}"

      expect(@roller.name).to appear_before(@hammer.name)
    end

end
