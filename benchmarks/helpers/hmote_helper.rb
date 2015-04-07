require_relative "../../lib/hmote"

include HMote::Helpers

def hmote(params)
  super(MOTE_TEMPLATE, params)
end
