import pygame
import os

os.environ['SDL_VIDEO_WINDOW_POS'] = "%d,%d" % (50,50)

def main():
	screenW = 1250
	screenH = 650
	screen = pygame.display.set_mode([screenW, screenH])

	pygame.init()
	pygame.display.set_caption('Naruto')
	clock = pygame.time.Clock()

	running = True

	while running:
		pygame.display.update()
		clock.tick(60)

	pygame.quit()
	quit()


main()