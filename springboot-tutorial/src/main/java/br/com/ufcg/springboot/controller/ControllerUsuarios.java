package br.com.ufcg.springboot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import br.com.ufcg.springboot.model.Usuario;
import br.com.ufcg.springboot.service.UsuarioService;

@RequestMapping(value = "/Usuario")
@RestController
public class ControllerUsuarios {
	@Autowired
	private UsuarioService usuarioService;

	@RequestMapping(value = "/cadastrar")

	public ResponseEntity<Usuario> cadastrarUsuario(@RequestBody Usuario usuario) {
		Usuario usuarioCadastrado = usuarioService.cadastrarUsuario(usuario);
		if(usuarioCadastrado == null) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<>(usuarioCadastrado, HttpStatus.CREATED);

	}
}
