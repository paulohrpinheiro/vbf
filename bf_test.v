module main

fn test_add_one() {
	result := exec('+', '')
	assert result.output == ''
	assert result.memory[0] == 1
}

fn test_move_to_last_then_add_one() {
	result := exec('<+', '')
	assert result.output == ''
	assert result.memory[memory_len - 1] == 1
}

fn test_move_to_last_from_first_then_back() {
	result := exec('<>+', '')
	assert result.output == ''
	assert result.memory[0] == 1
}

fn test_get_capital_letter_a() {
	result := exec('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.', '')
	assert result.output == 'A'
	assert result.memory[0] == 65
}

// adapted from https://en.wikipedia.org/wiki/Brainfuck#Hello_World!
fn test_wikipedia_hello_world() {
	result := exec('++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.', '')
	assert result.output == 'Hello World!'
}

fn test_input_command_from_a_get_b() {
	result := exec(',+.', 'A')
	assert result.output == 'B'
}
