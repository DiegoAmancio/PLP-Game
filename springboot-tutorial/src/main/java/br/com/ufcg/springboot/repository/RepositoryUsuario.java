package br.com.ufcg.springboot.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import br.com.ufcg.springboot.model.Usuario;

public interface RepositoryUsuario extends JpaRepository<Usuario, Integer>{

}
