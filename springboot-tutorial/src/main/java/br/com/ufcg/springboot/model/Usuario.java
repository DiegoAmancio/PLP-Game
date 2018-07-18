package br.com.ufcg.springboot.model;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class Usuario {
	@Id
	private  String matricula;
	private String nome;
	public Usuario(String matricula, String nome) {
		super();
		this.matricula = matricula;
		this.nome = nome;
	}
	public Usuario() {
		
	}
	
	public String getMatricula() {
		return matricula;
	}
	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	
	
	
	
}
