package br.com.ufcg.springboot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import br.com.ufcg.springboot.model.TodoNote;
import br.com.ufcg.springboot.service.TodoService;

@RestController
@RequestMapping(value = "/api")
@CrossOrigin(origins = "*")
public class TodoController {

	@Autowired
	TodoService todoService;

	@RequestMapping(value = "/todo", method = RequestMethod.GET)
	public List<TodoNote> getAll() {
		return todoService.getAll();
	}

	@RequestMapping(value = "/todo", method = RequestMethod.POST)
	public TodoNote save(@RequestBody TodoNote todo) {
		return todoService.save(todo);
	}

	@RequestMapping(value = "/todo/{id}", method = RequestMethod.GET)
	public TodoNote getById(@PathVariable("id") Long id) {
		return todoService.getById(id);
	}

	@RequestMapping(value = "/todo/{id}", method = RequestMethod.PUT)
	public ResponseEntity<TodoNote> update(@PathVariable("id") Long id, @RequestBody TodoNote todo) {
		TodoNote updatedTodo = todoService.update(todo, id);
		return new ResponseEntity<TodoNote>(updatedTodo, HttpStatus.OK);
	}

	@RequestMapping(value = "/todo/{id}", method = RequestMethod.DELETE)
	public ResponseEntity<TodoNote> delete(@PathVariable("id") Long id) {
		TodoNote todo = todoService.delete(id);
		return new ResponseEntity<TodoNote>(todo, HttpStatus.OK);
	}
}