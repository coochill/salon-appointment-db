#! /bin/bash

# Use psql command for test or production databases
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=salontest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"
fi

# Function to display services
display_services() {
  echo -e "\n~~~~~ MY SALON ~~~~~"
  echo -e "\nWelcome to My Salon, how can I help you?\n"
  
  # Query the services table and display a numbered list
  services=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;")
  
  echo "$services" | while IFS="|" read service_id name
  do
    echo "$service_id) $name"
  done
}

# Display the services list
display_services

# Prompt the user to select a service
while true; do
  echo -e "\nPlease enter the service number:"
  read SERVICE_ID_SELECTED

  # Check if the service ID is valid
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
  
  if [[ -n $SERVICE_NAME ]]; then
    # If valid, break the loop
    break
  else
    echo -e "\nI could not find that service. What would you like today?"
    display_services
  fi
done

#phone
echo -e "What's your phone number? "
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

#add phone number
if [[ -z $CUSTOMER_NAME ]]; then
  echo -e "Your phone number doesn't exist. What's your name? "
  read CUSTOMER_NAME

INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  if [[ $INSERT_CUSTOMER_RESULT == "INSERT 0 1" ]]; then
    echo -e "\nNew customer added: $CUSTOMER_NAME with phone $CUSTOMER_PHONE."
  else
    echo -e "\nFailed to add the new customer. Please try again."
    exit 1
  fi
fi

# customer id of the customer
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

#appointment
echo -e "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

#confirmation
if [[ $INSERT_APPOINTMENT_RESULT == "INSERT 0 1" ]]; then
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  exit 0
else
  echo -e "\nSomething went wrong. Please try again."
  exit 1
fi

