module CartsHelper
  def province_tax_rates
    {
      "Ontario" => { pst: 0.0, gst: 0.0, hst: 0.13 },
      "Quebec" => { pst: 0.09975, gst: 0.05, hst: 0.0 },
      "British Columbia" => { pst: 0.07, gst: 0.05, hst: 0.0 },
      "Alberta" => { pst: 0.0, gst: 0.05, hst: 0.0 },
      "Manitoba" => { pst: 0.07, gst: 0.05, hst: 0.0 },
      "Saskatchewan" => { pst: 0.06, gst: 0.05, hst: 0.0 },
      "Newfoundland and Labrador" => { pst: 0.0, gst: 0.0, hst: 0.15 },
      "New Brunswick" => { pst: 0.0, gst: 0.0, hst: 0.15 },
      "Prince Edward Island" => { pst: 0.0, gst: 0.0, hst: 0.15 },
      "Nova Scotia" => { pst: 0.0, gst: 0.0, hst: 0.15 },
      "Northwest Territories" => { pst: 0.0, gst: 0.05, hst: 0.0 },
      "Yukon" => { pst: 0.0, gst: 0.05, hst: 0.0 },
      "Nunavut" => { pst: 0.0, gst: 0.05, hst: 0.0 }
    }.tap do |rates|
      rates.default = { pst: 0.0, gst: 0.05, hst: 0.0 }
    end
  end
end
