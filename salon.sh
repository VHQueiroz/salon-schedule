#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# Exibe os serviços disponíveis antes da primeira entrada
MAIN_MENU(){
echo -e "\n~~~~~ My Salon ~~~~~\n"
echo -e "\nWelcome to the Salon! Here are our services:\n"
echo -e "1) cut\n2) lights\n3) hidratyon"
read SERVICE_ID_SELECTED
}
MAIN_MENU

# Solicita ao usuário a escolha do serviço
while true; do
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
  if [[ -n "$SERVICE_NAME" ]]; then
    break
  else
    echo -e "\nInvalid selection. Please choose a valid service ID."
    MAIN_MENU
  fi
done

# Solicita o telefone do cliente
echo -e "\nEnter your phone number:"
read CUSTOMER_PHONE

# Verifica se o cliente já está cadastrado
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")

if [[ -z "$CUSTOMER_NAME" ]]; then
  echo -e "\nYou are not in our system. Please enter your name:"
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
fi

# Solicita o horário do serviço
echo -e "\nEnter the time for your appointment:"
read SERVICE_TIME

# Obtém o ID do cliente
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")

# Insere o agendamento
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

# Confirmação final
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.\n"
