#!/usr/bin/env ruby

require 'gosu'

SIZE_X = 640
SIZE_Y = 480

module ZOrder
  Background, Ball, UI = *0..2
end


class Ball

  attr_reader :x, :y, :vel_x, :vel_y

  def initialize(window)
    @image = Gosu::Image.new(window, 'media/kugel.png', false)
    @x = @y = 1
    @vel_y = @vel_x = 20
  end

  def kick
    @vel_y += 10
    @vel_x += 10
  end

  def update_pos
    # bounce on edges
    @vel_x = -@vel_x.abs if @x + @image.width >= SIZE_X
    @vel_x = @vel_x.abs if @x <= 0
    @vel_y = @vel_y.abs if @y <= 0
    @vel_y = -@vel_y.abs if @y + @image.height >= SIZE_Y

    # gravity
    @vel_y += 0.3 if (@vel_y < 10 && (@y + @image.height < SIZE_Y))

    # friction
    @vel_y *= 0.992
    @vel_x *= 0.99

    # stop micro movement
    @vel_y = 0 if @vel_y.abs < 2.5 && (@y + @image.height >= SIZE_Y)
    @vel_x = 0 if @vel_x.abs < 0.2

    # move
    @y += @vel_y
    @x += @vel_x
  end


  def draw
    @image.draw(@x, @y, ZOrder::Ball)
  end

end


class GameWindow < Gosu::Window

  def initialize
    super SIZE_X, SIZE_Y, false
    self.caption = "Gosu Flipper"

    @ball = Ball.new(self)
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

  end

  def update

    if button_down? Gosu::KbUp
      @ball.kick
    end

    @ball.update_pos

  end

  def draw
    @ball.draw
    @font.draw("Press ↑ to kick ball", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end


  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end


end


window = GameWindow.new
window.show
