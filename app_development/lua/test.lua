-- function constructor
getTableKeyValuePairs = function(t)
  -- Iterate through the table and print each key value pair
  --for key,value in pairs(t) do
  --  print (key, value)
  --end
  -- Or, use the next() interator this way
  for key,value in next,t,nil do
    print (key, value)
  end
end

-- function constructor
getTableLength = function(t)
  return # t
end

-- function constructor
x = function (user, value1, value2, value3)
  -- construct the initial table
  numbers = { user, value1, value2, value3 }
  -- Insert 99 at the second key of the table
  table.insert(numbers,2,99)
  -- print the table
  print ('Table with additional key')
  getTableKeyValuePairs(numbers)
  length = getTableLength(numbers)
  print ("Table's length is " .. length)
  -- remove an element from the table
  table.remove(numbers, 2)
  -- print the table
  print ('Table without additional key')
  getTableKeyValuePairs(numbers)
  length = getTableLength(numbers)
  print ("Table's length is " .. length)
end
-- execute
x("bob", 255, 108, 316)