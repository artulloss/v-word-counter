import os

fn main() {
	path, case_sensitive, lines := parse_input() or {
		println(err)
		return
	}
	// Filter out anything that isn't a letter
	mut words_only_letters := []string{}
	for line in lines {
		words := line.split(' ')
		for word in words {
			words_only_letters << remove_punctuation(word)
		}
	}

	// Count the words
	words_and_counts := count_words(words_only_letters, case_sensitive)

	// Sort the words
	mut words := words_and_counts.keys()
	words.sort()

	// Print the words
	println("These are the words in the file at $path (Case sensitive: $case_sensitive)")
	for word in words {
		if word == '' {
			continue
		}
		count := words_and_counts[word]
		println("$word => $count")
	}
}

fn parse_input() ?(string, bool, []string) {
	// Parse arguments
	mut path := ""
	if os.args.len >= 2 {
		path = os.args[1]
	} else {
		path = os.input("Please enter the path of a file to read: ")
	}
	// Open file and read lines
	lines := os.read_lines(path.trim_space()) or {
		return error("Failed to open file at $path")
	}
	mut case_sensitive := false
	if os.args.len == 3 {
		case_sensitive = parse_bool(os.args[2])
	} else {
		case_sensitive = parse_bool(os.input("Do you want case sensitivity? (y,n): "))
	}
	return path, case_sensitive, lines
}

fn parse_bool(parse_string string) bool {
	return parse_string.to_lower() in ["y", "yes"]
}

fn remove_punctuation(word string) string {
	mut new_word := ""
	for char in word {
		if char.is_letter() {
			new_word += char.str()
		}
	}
	return new_word
}

fn count_words(words []string, case_sensitive bool) map[string]int {
	mut word_count := map[string]int
	for w in words {
		mut word := w
		if !case_sensitive {
			word = word.to_lower()
		}
		if !(word in word_count) {
			word_count[word] = 0
		}
		word_count[word]++
	}
	return word_count
}