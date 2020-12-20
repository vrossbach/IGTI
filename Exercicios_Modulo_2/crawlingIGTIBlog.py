import scrapy


class CrawlingigtiblogSpider(scrapy.Spider):
    name = 'crawlingIGTIBlog'
    allowed_domains = ['www.igti.com.br/blog']
    start_urls = ['http://www.igti.com.br/blog/']

    def parse(self, response):
        pass
