//
//  main.swift
//  Challenge
//
//  Created by PEDRO CRISTIANO BATISTA CANUTE on 14/11/25.
//

import Foundation

//ENUM ERROS

enum ErroFeitico: Error {
    case feiticoNaoEncontrado
    case manaInsuficiente
}

//STRUCTS JOGADOR E INIMIGO

struct Jogador {
    var nome: String
    var vida: Int = 80
    var mana: Int = 50
    var grimorio: Set<String> //Set de feiticos que pode aprender, para valores unicos
}

struct Inimigo {
    var nome: String
    var vida: Int
    var dano: Int
}

// LISTA INIMIGOS E GERAR INIMIGOS

//Cria um array de struct de inimigos
let listaDeInimigo: [Inimigo] = [ Inimigo(nome: "Goblin", vida: 45, dano: 10), Inimigo(nome: "Esqueleto", vida: 45, dano: 14), Inimigo(nome: "Orc", vida: 60, dano: 15), Inimigo(nome: "Mago Sombrio", vida: 55, dano: 18), Inimigo(nome: "Necromante", vida: 50, dano: 22)]

//Funcao que escolhe aleatoriamente um inimigo no array e retonar o inimigo escolhido
func gerarInimigo() -> Inimigo {
    let indice = Int.random(in: 0..<listaDeInimigo.count)
    return listaDeInimigo[indice]
}

// FEITICOS E SUAS FUNCOES

//Dicionario de feiticos
let poderDosFeiticos: [String: (dano: Int, custo: Int)] = ["Fogo" : (10, 8), "Gelo" : (10, 8), "Raio" : (14, 12), "Meteoro" : (20, 20), "Nevasca" : (20, 20)]

let feiticosDisponiveis = ["Fogo", "Gelo", "Raio", "Meteoro", "Nevasca"] //Array de feiticos disponiveis

//Funcao que verifica se o que foi digitado eh valido, se sim, insere uma nova linha no grimorio (Set) do jogador
func aprenderFeitico(aprendiz: Jogador, feitico: String) throws -> Jogador {
    
    if !feiticosDisponiveis.contains(feitico) {
        throw ErroFeitico.feiticoNaoEncontrado
    }
    
    var jogadorAtualizado = aprendiz
    jogadorAtualizado.grimorio.insert(feitico)
    return jogadorAtualizado
}

//Funcao que verifica o feitico, seu dano e custo de mana, decrementa a mana do jogador se for um valor valido e retonar o novo status do jogador e o dano causado
func lancarFeitico(quem: Jogador, feitico: String) throws -> (Jogador, Int) {
    
    let dados = poderDosFeiticos[feitico]
    
    if dados == nil {
        throw ErroFeitico.feiticoNaoEncontrado
    }
    
    let dano = dados!.dano
    let custo = dados!.custo
    
    if jogador.mana < custo {
        throw ErroFeitico.manaInsuficiente
    }
    var jogadorModificado = quem
    jogadorModificado.mana -= custo
    return (jogadorModificado, dano)
}

//Funcao batalhar que simula uma batalha com um inimigo aleatorio.
func batalhar(participante: Jogador) -> Jogador {
    var jogadorAtual = participante
    var inimigo = gerarInimigo()
    print("\nUm \(inimigo.nome) Simulacro apareceu!\n")
    
    while inimigo.vida > 0 {
        
        print("\(jogadorAtual.nome) - Vida: \(jogadorAtual.vida) | Mana: \(jogadorAtual.mana)")
        print("\(inimigo.nome) - Vida: \(inimigo.vida)\n")
        
        let listaFeiticos = Array(jogadorAtual.grimorio).sorted() //Aqui converte o Set para array, para sempre exibir de maneira ordenada
        
        if listaFeiticos.isEmpty {
            print("Voce nao conhece nenhum feitico")
            return jogadorAtual
        }
        
        print("Escolha um feitico para lancar:")
        
        for (i, nomeFeitico) in listaFeiticos.enumerated() {
            if let dados = poderDosFeiticos[nomeFeitico] {
                print("\(i) - \(nomeFeitico) (Dano: \(dados.dano), Custo: \(dados.custo))")
            }
        }
        
        let input = readLine() ?? ""
        let numero = Int(input) ?? 0
        
        if  numero < 0 || numero > listaFeiticos.count {
            print("Opcao invalida\n")
            continue
        }
        let escolhido = listaFeiticos[numero]
        
        do {
            let resultado = try lancarFeitico(quem: jogadorAtual, feitico: escolhido)
            jogadorAtual = resultado.0
            let dano = resultado.1
            
            inimigo.vida -= dano
            print("\nVoce lancou \(escolhido) e causou \(dano) de dano")
            jogadorAtual.vida -= inimigo.dano
            print("O inimigo atacou e causou \(inimigo.dano) de dano!\n")
            
        } catch ErroFeitico.manaInsuficiente {
            print("Mana insuficiente\n")
            continue
        } catch {
            print("Erro desconhecido!\n")
            continue
        }
        
        if inimigo.vida <= 0 {
            print("Voce derrotou o \(inimigo.nome)!\n")
            break
        }
        
        
        if jogadorAtual.vida <= 0 {
            print("Voce morreu! Aprenda mais feiticos para prevalescer na batalha")
            jogadorAtual.vida = 60
            return jogadorAtual
        }
    }
    return jogadorAtual
}
    
//MENU

//Funcao que concatena texto e imprime o menu na tela, sempre que chamada e verifica o input do jogador
func printarMenu() -> Int {
    var menu = ""
    menu += "\n === MENU PRINCIPAL ===\n"
    menu += "1 - Aprender Feitico\n"
    menu += "2 - Ver Grimorio\n"
    menu += "3 - Enfrentar um Simulacro\n"
    menu += "4 - Sair do Jogo\n"
    menu += "Escolha uma opcao:\n"
    
    print(menu)
    
    let entrada = readLine() ?? ""
    let opcao = Int(entrada) ?? 0
    
    return opcao
}

//= = = = = = = Inicio do Jogo = = = = = = = =

print("Bem vindo a Academia de Magia")
print("Digite seu nickname:")
let nomeInserido = readLine() ?? "Jogador"

var jogador = Jogador(nome: nomeInserido, grimorio: []) //Guarda na struct Jogador o nome e quantidade de feiticos aprendidos do jogador

var jogando = true

while jogando {
    
    let escolheu = printarMenu() //Funcao que retorna qual opcao o jogador escolheu
    
    switch escolheu { //Muda o comportamento do jogo conforme o que foi digitado, de acordo com as opcoes do menu
    case 1:
        print("Seja bem vindo(a) a Biblioteca de Magias da Academia")
        print("Escolha a seccao de livros que quer obter maestria")
        print("\nFeiticos Disponiveis:")
        
        for feiticos in feiticosDisponiveis {
            print("- \(feiticos)")
        }
        
        print("Digite o nome do feitico:")
        let escolha = readLine() ?? ""
        
        do {
            jogador = try aprenderFeitico(aprendiz: jogador, feitico: escolha)
            print("\nVoce aprendeu o feitico \(escolha)!")
        } catch {
            print("Feitico invalido")
        }
    case 2:
        print("\n=== GRIMORIO ===")
        print("Gracas ao resultado do seus estudos, esta eh a lista de Feiticos aprendidos por \(jogador.nome):")
        let arrayGrimorio = Array(jogador.grimorio).sorted()
        
        for feiticosLista in arrayGrimorio {
            print("\(feiticosLista)")
        }
        
    case 3:
        jogador = batalhar(participante: jogador)
    case 4:
        print("Saindo do jogo...")
        jogando = false
    default:
        print("Opcao invalida")
    }
}
