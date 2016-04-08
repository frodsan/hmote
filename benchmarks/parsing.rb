# frozen_string_literal: true

require_relative "helper"

template = MOTE_TEMPLATE

benchmark do |x|
  x.report("hmote") do
    HMote.parse(template, self, [:text])
  end
end

memory("hmote") do
  HMote.parse(template, self, [:text])
end
