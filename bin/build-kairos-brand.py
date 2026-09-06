#!/usr/bin/env python
"""
build-kairos-brand.py
Monta os 3 SVGs oficiais de branding do Kairos CRM a partir do logo
original enviado pelo Pastor (logo-original.jpg).

Estrategia:
- Recorta a parte superior do logo (ampulheta + "K" + circulo) sem
  o wordmark "KAIROS TECNOLOGIA".
- Cria PNGs horizontais com a ampulheta + texto "Kairos CRM" do lado
  (light e dark).
- Cria PNG quadrado so com a ampulheta (thumbnail).
- Embute tudo em SVG via base64 (data: URI) para ficar independente
  de arquivos externos e funcionar como .svg puro.
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageOps
import base64
import io

REPO = Path(__file__).resolve().parent.parent
BA = REPO / 'public' / 'brand-assets'
SRC = BA / 'logo-original.jpg'

# --- helpers ---------------------------------------------------------------
def load_b64(path: Path) -> str:
    data = path.read_bytes()
    return base64.b64encode(data).decode('ascii')


def crop_ampulheta(src: Image.Image) -> Image.Image:
    """Recorta a parte superior do logo (circulo + ampulheta) sem o wordmark.
    O original 1254x1254 - a ampulheta ocupa aprox os primeiros 65% verticais."""
    w, h = src.size
    # crop central horizontal, ate ~58% da altura (corta o wordmark embaixo)
    top = 0
    bottom = int(h * 0.58)
    return src.crop((0, top, w, bottom))


def find_font(size: int) -> ImageFont.FreeTypeFont:
    candidates = [
        r'C:\Windows\Fonts\segoeuib.ttf',  # Segoe UI Bold
        r'C:\Windows\Fonts\segoeui.ttf',
        r'C:\Windows\Fonts\arialbd.ttf',
        r'C:\Windows\Fonts\arial.ttf',
    ]
    for c in candidates:
        if Path(c).exists():
            return ImageFont.truetype(c, size)
    return ImageFont.load_default()


def make_horizontal(amp: Image.Image, label: str, size: int = 800) -> Image.Image:
    """Logo horizontal: ampulheta a esquerda + wordmark a direita."""
    amp_h = size
    # ampulheta quadrada ja vem; mantem quadrada mas escala pra altura alvo
    amp_img = amp.copy()
    amp_img.thumbnail((amp_h, amp_h), Image.Resampling.LANCZOS)

    # wordmark - texto MENOR pra caber no canvas
    font_big = find_font(int(size * 0.20))   # antes 0.32 - agora 0.20
    font_small = find_font(int(size * 0.075))  # antes 0.10 - agora 0.075

    # medir texto com mais folga
    tmp = Image.new('RGBA', (1, 1))
    td = ImageDraw.Draw(tmp)
    bbox_big = td.textbbox((0, 0), 'Kairos', font=font_big)
    bbox_small = td.textbbox((0, 0), 'CRM', font=font_small)
    w_big = bbox_big[2] - bbox_big[0]
    w_small = bbox_small[2] - bbox_small[0]
    text_w = max(w_big, w_small) + int(size * 0.05)
    text_h = (bbox_big[3] - bbox_big[1]) + (bbox_small[3] - bbox_small[1]) + int(size * 0.05)

    gap = int(size * 0.08)
    total_w = amp_img.width + gap + text_w + int(size * 0.05)  # padding direito
    total_h = max(amp_img.height, text_h) + int(size * 0.05)

    canvas = Image.new('RGBA', (total_w, total_h), (0, 0, 0, 0))
    canvas.paste(amp_img, (0, (total_h - amp_img.height) // 2), amp_img)

    # textos
    draw = ImageDraw.Draw(canvas)
    text_x = amp_img.width + gap
    base_y = (total_h - text_h) // 2
    # "Kairos" em dourado
    gold = (212, 175, 55, 255)
    blue = (37, 99, 235, 255)
    draw.text((text_x, base_y - bbox_big[1]), 'Kairos', font=font_big, fill=gold)
    # "CRM" em azul, abaixo, centralizado no text_w
    draw.text((text_x + (text_w - w_small) // 2, base_y + (bbox_big[3] - bbox_big[1]) + int(size * 0.02) - bbox_small[1]),
              'CRM', font=font_small, fill=blue)
    return canvas


def write_svg_with_image(out_path: Path, png_bytes: bytes, width: int, height: int, dark: bool = False):
    """Escreve SVG com a imagem PNG embutida em base64 (data: URI)."""
    b64 = base64.b64encode(png_bytes).decode('ascii')
    bg = '#0f172a' if dark else '#ffffff'
    svg = f'''<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 {width} {height}" width="{width}" height="{height}">
  <rect width="100%" height="100%" fill="{bg}"/>
  <image x="0" y="0" width="{width}" height="{height}" xlink:href="data:image/png;base64,{b64}"/>
</svg>
'''
    out_path.write_text(svg, encoding='utf-8')


# --- main ------------------------------------------------------------------
def main():
    if not SRC.exists():
        raise SystemExit(f'logo original nao encontrado: {SRC}')

    src = Image.open(SRC).convert('RGBA')
    print(f'Source: {SRC}  {src.size}')

    # 1. crop ampulheta (sem wordmark)
    amp = crop_ampulheta(src)
    amp = amp.resize((600, 600), Image.Resampling.LANCZOS)
    amp_path = BA / 'ampulheta.png'
    amp.save(amp_path, 'PNG', optimize=True)
    print(f'  ampulheta: {amp_path}')

    # 2. logo horizontal (light)
    h_light = make_horizontal(amp, 'Kairos CRM', size=800)
    h_light_path = BA / 'logo-horizontal.png'
    h_light.save(h_light_path, 'PNG', optimize=True)
    print(f'  horizontal light: {h_light_path} {h_light.size}')

    # 3. logo horizontal (dark) - fundo escuro no canvas
    h_dark = make_horizontal(amp, 'Kairos CRM', size=800)
    # converter ampulheta pra ficar visivel em fundo escuro (jA e por causa do
    # circulo preto, mas o fundo do PNG e transparente, entao fica ok)

    # 4. logo_thumbnail (so ampulheta, quadrado)
    thumb = amp.copy()
    thumb = thumb.resize((512, 512), Image.Resampling.LANCZOS)
    thumb_path = BA / 'logo-thumbnail.png'
    thumb.save(thumb_path, 'PNG', optimize=True)
    print(f'  thumbnail: {thumb_path}')

    # 5. gerar SVGs finais que o Chatwoot referencia
    write_svg_with_image(BA / 'logo.svg', h_light_path.read_bytes(), h_light.size[0], h_light.size[1], dark=False)
    write_svg_with_image(BA / 'logo_dark.svg', h_light_path.read_bytes(), h_light.size[0], h_light.size[1], dark=True)
    write_svg_with_image(BA / 'logo_thumbnail.svg', thumb_path.read_bytes(), 512, 512, dark=False)
    print(f'  SVGs gerados em {BA}')

    print('Concluido.')


if __name__ == '__main__':
    main()
