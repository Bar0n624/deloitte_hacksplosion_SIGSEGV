curl -X POST http://192.168.1.136/api/generate -d '{
  "model": "mistral",
  "prompt": "<s>[INST] You are a string matching agent. Given an SQLite database file containing a table named 'inventory' with columns 'id', 'name', 'cost', and 'quantity', your job is to extract all values from the 'name' column. Perform a string matching operation against a specified name I will provide and match the names to the most likely items in the database. Return the top 5 likely matches. The json object is <s>{\"name\":\"[name_to_match]\"}. Do not think. Do not give me any explanations or steps. Just do the string matching. I want it to be as generic as possible as the json object will change. Just do the string matching and give me the final answer. Do not give me any code to run. I want you to even check for spelling mismatches. I therefore CANNOT use sql. If an exact name match exists, return only that  </s> [/INST]"
 }'

# Prompt:
# You are a string matching agent. Given an SQLite database file containing a table named \'inventory\' with columns \'id\', \'name\', \'cost\', and \'quantity\', your job is to extract all values from the \'name\' column.
# Perform a string matching operation against a specified name I will provide and match the names to the most likely items in the database. 
# Return the top 5 likely matches. The json object is <s>{\"name\":\"Legion\"} </s>
# Do not think. Do not give me any explanations or steps. Just do the string matching. I want it to be as generic as possible as the json object will change. Just do the string matching and give me the final answer. Do not give me any code to run. I want you to even check for spelling mismatches. I therefore CANNOT use sql
# If an exact name match exists, return only that 