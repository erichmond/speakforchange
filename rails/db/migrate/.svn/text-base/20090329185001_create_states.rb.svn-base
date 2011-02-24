class CreateStates < ActiveRecord::Migration

  STATES = %W{ ALABAMA AL ALASKA AK ARIZONA AZ ARKANSAS AR CALIFORNIA CA COLORADO CO CONNECTICUT CT DELAWARE DE FLORIDA FL GEORGIA GA HAWAII HI IDAHO ID ILLINOIS IL INDIANA IN IOWA IA KANSAS KS KENTUCKY KY LOUISIANA LA MAINE ME MARYLAND MD MASSACHUSETTS MA MICHIGAN MI MINNESOTA MN MISSISSIPPI MS MISSOURI MO MONTANA MT NEBRASKA NE NEVADA NV NEW\ HAMPSHIRE NH NEW\ JERSEY NJ NEW\ MEXICO NM NEW\ YORK NY NORTH\ CAROLINA NC NORTH\ DAKOTA ND OHIO OH OKLAHOMA OK OREGON OR PENNSYLVANIA PA RHODE\ ISLAND RI SOUTH\ CAROLINA SC SOUTH\ DAKOTA SD TENNESSEE TN TEXAS TX UTAH UT VERMONT VT VIRGINIA VA WASHINGTON WA WEST\ VIRGINIA WV WISCONSIN WI WYOMING WY }


  def self.up
    create_table :states do |t|
      t.string :abbreviation
      t.string :name
      t.integer :messages_count, :default => 0

      t.timestamps
    end

    State.reset_column_information
    STATES.each_slice(2) do |name, abbrev|
      s = State.create :name => name, :abbreviation => abbrev
      s.messages_count = Message.count(:conditions => {:state => s.abbreviation})
      s.save

    end
  end

  def self.down
    drop_table :states
  end
end
