package br.com.ufcg.springboot.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import br.com.ufcg.springboot.model.Usuario;
import br.com.ufcg.springboot.repository.RepositoryUsuario;

@Service
public class UsuarioService {
	@Autowired
	private RepositoryUsuario repositorioUsuario;
	
	public Usuario cadastrarUsuario(Usuario usuario) {
		return repositorioUsuario.save(usuario);
		
	}
	
	
}
