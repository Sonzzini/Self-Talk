//
//  OnboardingView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 15/04/24.
//

import SwiftUI

struct OnboardingView: View {
	@EnvironmentObject var vm: ViewModel
	@Environment(\.dismiss) private var dismiss
	
	@State var buttonIsPressed: Bool = false
	@State var pageIndex: Int = 0
	
	var body: some View {
		NavigationStack {
			ZStack {
				Image("Wallpaper")
					.resizable()
					.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
					.scaledToFit()
				
				if pageIndex == 0 {
					VStack {
						Text("Um olá do Self Talk!")
							.font(.system(size: 50))
							.fontWeight(.semibold)
							.padding(.top, 100)
						
						Text("Queremos te ajudar a sair da sua zona de conforto, te transportando a situações que podem ser difíceis em primeiro momento...")
							.font(.system(size: 25))
							.frame(width: UIScreen.main.bounds.width/2)
							.multilineTextAlignment(.center)
							.padding(.top, 50)
						
						Text("Mas não se assuste!")
							.font(.system(size: 25))
							.padding(.top, 50)
						
						Text("A prática leva à perfeição")
							.font(.system(size: 25))
							.padding(.top, 50)
												

						HStack {
							nextPageButton
						}

					}
				}
				else if pageIndex == 1 {
					VStack {
						
						HStack(alignment: .top, spacing: 35) {
							Image("ScenarioCard")
								.resizable()
								.scaledToFit()
							

							Text("Os cenários estão aqui para simular situações e te inserirem nelas!")
								.font(.system(size: 25))
								
							
						}
						.frame(width: 550)
						
						Text("Eles terão um script personalizável na parte inferior da tela para te auxiliar no que precisa ser dito durante o cenário.")
							.font(.system(size: 25))
							.padding(.top, 30)
							.padding(.bottom, 30)
							.frame(width: 550)
						
						HStack(alignment: .top, spacing: 35) {
							Text("Com isso, geraremos um relatório que evidenciará o seu progresso!")
								.font(.system(size: 25))
							
							Image("ExampleScreen")
								.resizable()
								.scaledToFit()
						}
						.frame(width: 550)
						
						HStack {
							previousPageButton
							nextPageButton
						}
					}
				}
				else if pageIndex == 2 {
					VStack {
						
						Text("Vamos começar?")
							.font(.system(size: 40))
							.fontWeight(.semibold)
							.padding(.top, 30)
							.padding(.bottom, 30)
							.frame(width: 550)
						
						HStack {
							previousPageButton
							beginButton
						}
					}
				}
			}
			.foregroundStyle(.white)
		}
	}
}

#Preview {
	OnboardingView()
}

extension OnboardingView {
	private var nextPageButton: some View {
		Button {
			withAnimation(.easeInOut(duration: 0.2)) {
				buttonIsPressed.toggle()
				
				if pageIndex < 2 {
					pageIndex += 1
				}
				
				DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
					withAnimation(.easeInOut(duration: 1)) {
						buttonIsPressed.toggle()
					}
				}
			}
		} label: {
			Text("Próximo")
				.font(.title)
				.fontWeight(.semibold)
				.padding()
				.padding(.horizontal, 20)
				.foregroundStyle(.white)
				.background(buttonIsPressed ? Color.glaucous : Color.savoyBlue)
				.clipShape(RoundedRectangle(cornerRadius: 25))
		}
	}
	
	private var previousPageButton: some View {
		Button {
			withAnimation(.easeInOut(duration: 0.2)) {
				buttonIsPressed.toggle()
				
				if pageIndex > 0 {
					pageIndex -= 1
				}
				
				DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
					withAnimation(.easeInOut(duration: 1)) {
						buttonIsPressed.toggle()
					}
				}
			}
		} label: {
			Text("Anterior")
				.font(.title)
				.fontWeight(.semibold)
				.padding()
				.padding(.horizontal, 20)
				.foregroundStyle(.white)
				.background(buttonIsPressed ? Color.glaucous : Color.savoyBlue)
				.clipShape(RoundedRectangle(cornerRadius: 25))
		}
	}
	
	private var beginButton: some View {
		Button {
			dismiss()
		} label: {
			Text("Começar")
				.font(.title)
				.fontWeight(.semibold)
				.padding()
				.padding(.horizontal, 20)
				.foregroundStyle(.white)
				.background(Color.savoyBlue)
				.clipShape(RoundedRectangle(cornerRadius: 25))
		}
	}
}
