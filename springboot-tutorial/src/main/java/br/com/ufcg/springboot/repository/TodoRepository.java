package br.com.ufcg.springboot.repository;


import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import br.com.ufcg.springboot.model.TodoNote;


@Repository
@Transactional
public interface TodoRepository extends JpaRepository<TodoNote, Long> {

}