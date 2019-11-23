require 'json'
require 'hash_dot'
require "google/cloud/firestore"

firestore = Google::Cloud::Firestore.new project_id: 'dzicyludzie'

example_token = 'asdf'

def account_from_pa(token)
  acc_json =  JSON.parse(File.read('examples/getAccount.json')).to_dot
end

def accounts_from_pa(token)
  accs_json =  JSON.parse(File.read('examples/getAccounts.json')).to_dot
end

def transactions_from_pa(token)
  trs_json =  JSON.parse(File.read('examples/getTransactions.json')).to_dot
end

def more_than_2yo_account_check(trs_json)
  trs_json.transactions.map do |tr| 
    if Date.parse(tr.bookingDate) < Date.today - 730
      return true
    end
  end
  false
end

def more_than_5_out_transactions_in_last_month_check(trs_json)
  out_trs_counter = 0
  trs_json.transactions.map do |tr|
    if Date.parse(tr.bookingDate) > Date.today - 30 && tr.amount.to_f < 0
      out_trs_counter = out_trs_counter + 1
      if out_trs_counter > 5 
        return true 
      end
    end
  end
  false
end

def more_than_3_diffrent_beneficients_check(trs_json)
  beneficients = 0
  used_beneficients_ibans = []
  trs_json.transactions.map do |tr|
    if tr.amount.to_f < 0 && !used_beneficients_ibans.include?(tr.destinationIban)
      used_beneficients_ibans.push(tr.destinationIban)
      beneficients = beneficients + 1
      if beneficients > 3
        return true
      end
    end
  end
  false
end

def verify_request(trs_json)

  verification_checks = [ 
    more_than_2yo_account_check(trs_json),
    more_than_5_out_transactions_in_last_month_check(trs_json),
    more_than_3_diffrent_beneficients_check(trs_json)
  ]
  
  if verification_checks.include?(false)
    return false
  else
    return true
  end
end

### working loop ###
links_ref = firestore.col "link_requests"
query = links_ref.where "status", "=", 'pending_verification'
listener = query.listen do |snapshot|

  snapshot.docs.each do |link| 
    link.ref.update(status: 'in_verification')
    
    puts 'polishAPI connection and request mock'
    puts 'it should provide a JSON response' 

    if verify_request(transactions_from_pa(example_token))
      link.ref.update \
        status: 'verified',
        verification: true
    else
      link.ref.update \
        status: 'verified',
        verification: false
    end
  rescue 
    link.ref.update(status: 'verification_problem')
  end
end

sleep 5 while true
