require 'paggio'

describe Paggio::HTML do
  it 'builds an element' do
    html = Paggio.html! do
      div
    end

    expect(html.to_s).to eq("<div>\n</div>\n")
  end

  it 'builds an element with text content' do
    html = Paggio.html! do
      div "foo bar"
    end

    expect(html.to_s).to eq("<div>\n\tfoo bar\n</div>\n")

    html = Paggio.html! do
      div do
        "foo bar"
      end
    end

    expect(html.to_s).to eq("<div>\n\tfoo bar\n</div>\n")
  end

  it 'builds an element with attributes' do
    html = Paggio.html! do
      div class: :wut
    end

    expect(html.to_s).to eq("<div class=\"wut\">\n</div>\n")
  end

  it 'builds deeper trees' do
    html = Paggio.html! do
      div do
        span do
          "wut"
        end
      end
    end

    expect(html.to_s).to eq("<div>\n\t<span>\n\t\twut\n\t</span>\n</div>\n")
  end

  it 'sets classes with methods' do
    html = Paggio.html! do
      div.nice.element
    end
    
    expect(html.to_s).to eq("<div class=\"nice element\">\n</div>\n")
  end

  it 'nests when setting classes' do
    html = Paggio.html! do
      div.nice.element do
        span.nicer 'lol'
      end
    end

    expect(html.to_s).to eq("<div class=\"nice element\">\n\t<span class=\"nicer\">\n\t\tlol\n\t</span>\n</div>\n")
  end

  it 'joins class name properly' do
    html = Paggio.html! do
      i.icon[:legal]
    end

    expect(html.to_s).to eq("<i class=\"icon-legal\">\n</i>\n")
  end

  it 'sets the id' do
    html = Paggio.html! do
      div.omg!
    end

    expect(html.to_s).to eq("<div id=\"omg\">\n</div>\n")
  end
end
