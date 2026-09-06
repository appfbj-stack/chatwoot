#!/usr/bin/env python
"""
generate-kairos-pngs.py
Regenera todos os PNGs de favicon/icone da public/ com a marca Kairos CRM
a partir do logo original (logo-original.jpg).

Saida: 30 PNGs em public/ (favicon, apple, android, ms)
Resize: Pillow LANCZOS (alta qualidade)
"""
from PIL import Image, ImageOps
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
PUBLIC = REPO / 'public'
SRC = PUBLIC / 'brand-assets' / 'logo-original.jpg'

# (tamanho, output path relativo a public/)
TARGETS = [
    # favicons
    (16,  'favicon-16x16.png'),
    (32,  'favicon-32x32.png'),
    (96,  'favicon-96x96.png'),
    (512, 'favicon-512x512.png'),

    # favicon badge (notificacao)
    (16,  'favicon-badge-16x16.png'),
    (32,  'favicon-badge-32x32.png'),
    (96,  'favicon-badge-96x96.png'),

    # apple
    (57,  'apple-icon-57x57.png'),
    (60,  'apple-icon-60x60.png'),
    (72,  'apple-icon-72x72.png'),
    (76,  'apple-icon-76x76.png'),
    (114, 'apple-icon-114x114.png'),
    (120, 'apple-icon-120x120.png'),
    (144, 'apple-icon-144x144.png'),
    (152, 'apple-icon-152x152.png'),
    (180, 'apple-icon-180x180.png'),
    (180, 'apple-icon.png'),
    (180, 'apple-icon-precomposed.png'),
    (180, 'apple-touch-icon.png'),
    (180, 'apple-touch-icon-precomposed.png'),

    # android
    (36,  'android-icon-36x36.png'),
    (48,  'android-icon-48x48.png'),
    (72,  'android-icon-72x72.png'),
    (96,  'android-icon-96x96.png'),
    (144, 'android-icon-144x144.png'),
    (192, 'android-icon-192x192.png'),

    # ms
    (70,  'ms-icon-70x70.png'),
    (144, 'ms-icon-144x144.png'),
    (150, 'ms-icon-150x150.png'),
    (310, 'ms-icon-310x310.png'),
]


def main():
    if not SRC.exists():
        raise SystemExit(f'logo original nao encontrado: {SRC}')

    src = Image.open(SRC).convert('RGBA')
    print(f'Source: {SRC}  ({src.size[0]}x{src.size[1]})')
    print(f'Gerando {len(TARGETS)} icones em {PUBLIC}')

    for size, rel in TARGETS:
        out = PUBLIC / rel
        # square crop centralizado, depois resize
        cropped = ImageOps.fit(src, (size, size), method=Image.Resampling.LANCZOS, centering=(0.5, 0.5))
        cropped.save(out, 'PNG', optimize=True)
        print(f'  ok {out} ({size}x{size})')

    print('Concluido.')


if __name__ == '__main__':
    main()
