require "http/client"

def getContext
  endpoint = "http://#{ENV["AWS_LAMBDA_RUNTIME_API"]}/2018-06-01/runtime/invocation/next"
  res = HTTP::Client.get(endpoint)
  
  if res.status_code != 200 
    raise "Unexpected response when invoking: #{res.status_code}"
  end
    
  request_id = res.headers["Lambda-Runtime-Aws-Request-Id"]  
  context = res.body.lines[0]
  [request_id, context]
end

def sendResponse(request_id, context)
  endpoint = "http://#{ENV["AWS_LAMBDA_RUNTIME_API"]}/2018-06-01/runtime/invocation/#{request_id}/response"
  HTTP::Client.post(endpoint, body: context, headers: nil)
end

while true
  request_id, context = getContext
  sendResponse(request_id, context)
end