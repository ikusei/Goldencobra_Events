# == Schema Information
#
# Table name: goldencobra_events_event_registrations
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  event_pricegroup_id :integer(4)
#  canceled            :boolean(1)      default(FALSE)
#  canceled_at         :datetime
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

module GoldencobraEvents
  class EventRegistration < ActiveRecord::Base
    belongs_to :user, :class_name => User
    belongs_to :event_pricegroup
    
    scope :active, where(:canceled => false)

    before_save :is_registerable?

    def is_registerable?(list_of_pricegroup_ids=nil)
      # receives array of event_pricegroup_ids and checks them for 
      list_of_ids = []
      if list_of_pricegroup_ids == nil
        if self.user && self.user.present? && self.user.event_registration_ids
          list_of_ids << self.user.event_registrations.map(&:event_pricegroup_id)
        end
        list_of_ids << self.event_pricegroup_id
      else
        list_of_ids << list_of_pricegroup_ids
      end

      list_of_ids = list_of_ids.flatten.uniq

      error_msgs = {}
      mybool = true
      list_of_ids.each do |event_pricg|
        epricegroup = GoldencobraEvents::EventPricegroup.find_by_id(event_pricg)
        if epricegroup
          # is registration date valid?
          unless epricegroup.registration_date_valid
            error_msgs[:date_error] = "Registration date of pricegroup is not valid"
          end

          if epricegroup.event.present? && !epricegroup.event.registration_date_valid
            error_msgs[:date_error] = "Registration date of event is not valid"
          end

          # max number of (event) participants reached?
          if epricegroup.event.present? && epricegroup.event.max_number_of_participants_reached?
            error_msgs[:num_of_ev_part_reached] = "Maximum number of participants reached for event '#{epricegroup.event.title}'"
          end

          # max number of (pricegroup) participants reached?
          if epricegroup.max_number_of_participants_reached?
            error_msgs[:num_of_pricegroup_part_reached] = "Maximum number of participants reached for pricegroup '#{epricegroup.title}'"
          end

          # parent needs_registration? && registration_done?
          rtn_val = epricegroup.event.check_for_parent_registrations(list_of_ids) if epricegroup.event.present?
          error_msgs[:parent_error] = rtn_val unless rtn_val == true

          # is registration possible or is event mutually exclusive?
          sib_ex = epricegroup.event.siblings_exclusive?(list_of_ids) if epricegroup.event.present?
          error_msgs[:exclusivity_error] = sib_ex unless sib_ex == true
        end

      end
      return error_msgs.length > 0 ? error_msgs : true
    end

    def self.create_batch(list_of_pricegroup_ids, user)
      ev_reg = GoldencobraEvents::EventRegistration.new
      result = ev_reg.is_registerable?(list_of_pricegroup_ids)
      if result == true && list_of_pricegroup_ids.present? && list_of_pricegroup_ids.count > 0
        list_of_pricegroup_ids.each do |reg_id|
            GoldencobraEvents::EventRegistration.find_or_create_by_event_pricegroup_id_and_user_id(reg_id,user.id )
        end
      end
      return result
    end
  end
end
