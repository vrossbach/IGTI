# -*- coding: utf-8 -*-
"""
Created on Thu Dec 17 21:37:29 2020

@author: vivienrossbach
"""

import scrapy

class Items(scrapy.Item):
    categoria = scrapy.Field()
    categoriaURL = scrapy.Field()
    titulo = scrapy.Field()
    url = scrapy.Field()
    dtPostagem = scrapy.Field()
    comentarios = scrapy.Field()
    visualizacoes = scrapy.Field()
    
class IGTIBlogSpider(scrapy.Spider):
    name = 'Scraping IGTI Blog'
    def __init__(self, tag=None):
        url = 'https://www.igti.com.br/blog/'
        self.start_urls = [url]
    def parse(self, response):
        self.log('Acessando a URL: %s:' % response.url)

        artigos = response.xpath("//article")
        count = 0
        self.log('Total de artigos em destaque: %s' % str(len(response.css('article'))))
        for artigo in artigos:
            item = Items()
            count += 1
            categorias = artigo.xpath(".//div/div[@class='entry-category']//a")
            
            if len(categorias) == 1:
                item['categoria'] = ''.join(categorias.xpath('text()').extract())
                item['categoria URL'] = ''.join(categorias.xpath('@href').extract())
            else:
                cat = []
                catUrl = []
                for categoria in categorias:
                    cat.append(''.join(categoria.xpath('text()').extract()))
                    cat.append(', ')
                    catUrl.append(''.join(categoria.xpath('@href').extract()))
                    catUrl.append(', ')
                item['categoria'] = ''.join(cat)
                item['categoriaURL'] = ''.join(catUrl)
            print('Categoria: ', item['categoria'])
            titulo = artigo.xpath(".//h2[@class='entry-title h3']//a")
            item['titulo'] = ''.join(titulo.xpath('text()').extract())
            item['url'] = ''.join(titulo.xpath('@href').extract())
            
            metadata = artigo.xpath(".//div/div[@class='entry-meta']")
            data = metadata.xpath(".//div[@class='meta-item meta-date']/span[@class='updated']")
            item['dtPostagem'] = ''.join(data.xpath('text()').get())
            
            comentario = metadata.xpath(".//div[@class='meta-item meta-views']")
            item['comentarios'] = ''.join(visao.xpath('text()').get())
            
            yield item
        self.log('Artigos raspados: %s' % str(count))
        self.log('Fim da raspagem!')