package br.com.ufcg.springboot.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import br.com.ufcg.springboot.exception.RegisterNotFoundException;
import br.com.ufcg.springboot.model.TodoNote;
import br.com.ufcg.springboot.repository.TodoRepository;

@Service
public class TodoService {

	@Autowired
	private TodoRepository todoRepository;

	public List<TodoNote> getAll() {
		return todoRepository.findAll();
	}

	public TodoNote getById(Long id) {
		Optional<TodoNote> optTodo = todoRepository.findById(id);

		if (!optTodo.isPresent()) {
			throw new RegisterNotFoundException("Todo don't exists");
		}

		return optTodo.get();
	}

	public TodoNote save(TodoNote todo) {
		todoRepository.save(todo);
		return todo;
	}

	public TodoNote update(TodoNote todo, Long id) {
		Optional<TodoNote> optTodo = todoRepository.findById(id);

		if (!optTodo.isPresent()) {
			throw new RegisterNotFoundException("Todo don't exists");
		}

		TodoNote newTodo = optTodo.get();
		newTodo.setText(todo.getText());
		newTodo.setIsDone(todo.getIsDone());

		todoRepository.save(newTodo);

		return newTodo;
	}

	public TodoNote delete(Long id) {
		Optional<TodoNote> optTodo = todoRepository.findById(id);

		if (!optTodo.isPresent()) {
			throw new RegisterNotFoundException("Todo don't exists");
		}

		TodoNote todo = optTodo.get();
		todoRepository.delete(todo);

		return todo;
	}
}