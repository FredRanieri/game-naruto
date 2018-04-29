import pygame
import os

os.environ['SDL_VIDEO_WINDOW_POS'] = "%d,%d" % (200,50)

screenW = 1250
screenH = 650

bg = (0, 64, 128)

imgPlayerPath = 'image/kakashi.png'


class Actuator:
	def __init__(self, img, x, y):
		self.img = img
		
		self.x = x
		self.y = y
		self.imgSize = [(0, 0), (0, 0)]

		self.imgWalkControl = 0
		self.imgWalkR = [(5, 1165, 85, 75), (92, 1165, 80, 75),
						(175, 1165, 68, 75), (245, 1165, 80, 75),
						(325, 1165, 85, 75), (410, 1165, 85, 75)]
		self.imgWalkL = [(410, 4580, 85, 75), (325, 4580, 85, 75),
						(245, 4580, 80, 75), (175, 4580, 68, 75),
						(92, 4580, 80, 75), (5, 4580, 85, 75)]


	def walk(self, move, side):
		self.x += move*15

		pos = self.imgWalkControl % 6
		
		if side:
			self.imgSize = self.imgWalkR[pos]
		else:
			 self.imgSize = self.imgWalkL[pos]

		self.imgWalkControl += move

	def draw(self, screen):
		screen.blit(self.img, (self.x, self.y), (self.imgSize))
		

def main():
	screen = pygame.display.set_mode([screenW, screenH])

	imgPlayer = pygame.image.load(imgPlayerPath)

	player = Actuator(imgPlayer, 100, 100)

	pygame.init()
	pygame.display.set_caption('Naruto')
	clock = pygame.time.Clock()

	running = True
	right = False
	left = False

	while running:
		for event in pygame.event.get():
			#If quit pressed just close the game 
			if event.type == pygame.QUIT:
				running = False
			if event.type == pygame.KEYDOWN:
				if event.key == pygame.K_ESCAPE:
					running = False
				
				if event.key == pygame.K_RIGHT:
					right = True

				if event.key == pygame.K_LEFT:
					left = True
		
			if event.type == pygame.KEYUP:
				if event.key == pygame.K_RIGHT:
					right = False

				if event.key == pygame.K_LEFT:
					left = False

		if right:
			player.walk(1, True)
		elif left:
			player.walk(-1, False)

		screen.fill(bg)
		player.draw(screen)
		pygame.display.update()
		clock.tick(8)

	pygame.quit()
	quit()


main()