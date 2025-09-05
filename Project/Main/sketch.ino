struct Table
{
  int name;
  int input_cnt, output_cnt;
  int *input_names, *output_names;
  int* values;

  Table(int nn, int ii, int oo) {
    name = nn; input_cnt = ii; output_cnt = oo;
    input_names = (int*) malloc(input_cnt * sizeof(int));
    output_names = (int*) malloc(output_cnt * sizeof(int));
    values = (int*) malloc((1 << input_cnt) * sizeof(int));
  }

  int find_output(int name) {
    for (int i = 0; i < output_cnt; i++) {
      if (output_names[i] == name) return i;
    }
    return -1;
  }

  void print_table() {
    Serial.print("name: ");
    Serial.println(String(name));
    Serial.print("input_cnt: ");
    Serial.println(String(input_cnt));
    Serial.print("output_cnt: ");
    Serial.println(String(output_cnt));
    Serial.print("inputs: ");
    for (int i = 0; i < input_cnt; i++) {
      Serial.print(String(input_names[i]) + " ");
    }
    Serial.println();
    Serial.print("outputs: ");
    for (int i = 0; i < output_cnt; i++) {
      Serial.print(String(output_names[i]) + " ");
    }
    Serial.println();
    Serial.print("values: ");
    for (int i = 0; i < (1 << input_cnt); i++) {
      Serial.print(String(values[i]) + " ");
    }
    Serial.println();
    return;
  }
  
};

Table* tables = (Table*) malloc(sizeof(Table));
int TABLE_CNT = 0, TABLE_CAPACITY = 1, MAX_VARIABLE_NUMBER = 13;
int *variable_values = (int*) malloc(18 * sizeof(int));

void make_space_for_new_table() {
  TABLE_CAPACITY *= 2;
  Table* ptr = (Table*) malloc(TABLE_CAPACITY * sizeof(Table));
  for (int i = 0; i < TABLE_CNT; i++)
    ptr[i] = tables[i];
  free(tables);
  tables = ptr;
  return;
}

void clear_tables() {
  free(tables);
  tables = (Table*) malloc(sizeof(Table));
  TABLE_CNT = 0; TABLE_CAPACITY = 1; MAX_VARIABLE_NUMBER = 13;
  free(variable_values);
  variable_values = (int*) malloc(18 * sizeof(int));
}

void handle_query() {
  String input_string = Serial.readString();
  if (input_string == "clear") {
    clear_tables();
    Serial.println("Tables cleared!");
    return;
  }
  if (TABLE_CNT >= TABLE_CAPACITY)
    make_space_for_new_table();
  char *str_bad = strdup(input_string.c_str());
  char *token = strtok(str_bad, ",");
  int nn = atoi(token);
  token = strtok(NULL, ",");
  int ii = atoi(token);
  token = strtok(NULL, ",");
  int oo = atoi(token);
  token = strtok(NULL, ",");
  tables[TABLE_CNT] = Table(nn, ii, oo);
  for (int i = 0; i < ii; i++) {
    int new_input = atoi(token);
    MAX_VARIABLE_NUMBER = max(MAX_VARIABLE_NUMBER, new_input);
    token = strtok(NULL, ",");
    tables[TABLE_CNT].input_names[i] = new_input;
  }
  for (int i = 0; i < oo; i++) {
    int new_output = atoi(token);
    MAX_VARIABLE_NUMBER = max(MAX_VARIABLE_NUMBER, new_output);
    token = strtok(NULL, ",");
    tables[TABLE_CNT].output_names[i] = new_output;
  }
  int ind = 0;
  while (token != NULL) {
    tables[TABLE_CNT].values[ind++] = atoi(token);
    token = strtok(NULL, ",");
  }
  Serial.println("new table added!");
  tables[TABLE_CNT].print_table();
  Serial.println("--------");
  free(str_bad);
  TABLE_CNT += 1;
  return;
}

void initialize_inputs() {
  for (int i = 2; i <= 9; i++)
    variable_values[i] = digitalRead(i);
  return;
}

void clear_variable_values() {
  for (int i = 2; i <= MAX_VARIABLE_NUMBER; i++)
    variable_values[i] = -1;
  return;
}

int calculate_variable_value(int var) {
  if (variable_values[var] != -1)
    return variable_values[var];
  int good_index = -1;
  for (int i = 0; i < TABLE_CNT; i++) {
    if (tables[i].find_output(var) != -1) {
      good_index = i;
      break;
    }
  }
  if (good_index == -1) return -1;
  int ind = 0;
  for (int i = 0; i < tables[good_index].input_cnt; i++) {
    int xxx = calculate_variable_value(tables[good_index].input_names[i]);
    if (xxx == -1) return -1;
    ind *= 2; ind += xxx;
  }
  int mask = tables[good_index].values[ind];
  ind = tables[good_index].output_cnt - 1 - tables[good_index].find_output(var);
  return ((mask >> ind) & 1);
}

void process_circuit() {
  free(variable_values);
  variable_values = (int*) malloc((MAX_VARIABLE_NUMBER + 5) * sizeof(int));
  clear_variable_values();
  initialize_inputs();
  Serial.println("circuit information: ");
  for (int i = 10; i <= MAX_VARIABLE_NUMBER; i++)
    variable_values[i] = calculate_variable_value(i);
  for (int i = 2; i <= MAX_VARIABLE_NUMBER; i++) {
    if (variable_values[i] != -1)
      Serial.println(String(i) + ": " + String(variable_values[i]));
  }
  Serial.println("--------");
  for (int i = 10; i <= 13; i++) {
    if (variable_values[i] == 1) digitalWrite(i, HIGH);
    else digitalWrite(i, LOW);
  }
  return;
}

void setup() {
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  pinMode(4, INPUT);
  pinMode(5, INPUT);
  pinMode(6, INPUT);
  pinMode(7, INPUT);
  pinMode(8, INPUT);
  pinMode(9, INPUT);

  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);

  Serial.begin(9600);
  variable_values[2] = -1;
}

void loop() {
  for (int i = 2; i <= 9; i++) {
    if (digitalRead(i) != variable_values[i]) {
      process_circuit();
      break;
    }
  }
  if (Serial.available() > 0) {
    handle_query();
    process_circuit();
  }
}
