import 'dart:convert';

class BlogModel {
  int? id;
  DateTime? date;
  DateTime? dateGmt;
  Guid? guid;
  DateTime? modified;
  DateTime? modifiedGmt;
  String? slug;
  String? status;
  String? type;
  String? link;
  Guid? title;
  Content? content;
  Content? excerpt;
  int? author;
  int? featuredMedia;
  String? commentStatus;
  String? pingStatus;
  bool? sticky;
  String? template;
  String? format;
  Meta? meta;
  List<int>? categories;
  List<int>? tags;
  List<dynamic>? acf;
  BlogModelLinks? links;
  Embedded? embedded;

  BlogModel({
    this.id,
    this.date,
    this.dateGmt,
    this.guid,
    this.modified,
    this.modifiedGmt,
    this.slug,
    this.status,
    this.type,
    this.link,
    this.title,
    this.content,
    this.excerpt,
    this.author,
    this.featuredMedia,
    this.commentStatus,
    this.pingStatus,
    this.sticky,
    this.template,
    this.format,
    this.meta,
    this.categories,
    this.tags,
    this.acf,
    this.links,
    this.embedded,
  });

  factory BlogModel.fromRawJson(String str) => BlogModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
        id: json["id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        dateGmt: json["date_gmt"] == null ? null : DateTime.parse(json["date_gmt"]),
        guid: json["guid"] == null ? null : Guid.fromJson(json["guid"]),
        modified: json["modified"] == null ? null : DateTime.parse(json["modified"]),
        modifiedGmt: json["modified_gmt"] == null ? null : DateTime.parse(json["modified_gmt"]),
        slug: json["slug"],
        status: json["status"],
        type: json["type"],
        link: json["link"],
        title: json["title"] == null ? null : Guid.fromJson(json["title"]),
        content: json["content"] == null ? null : Content.fromJson(json["content"]),
        excerpt: json["excerpt"] == null ? null : Content.fromJson(json["excerpt"]),
        author: json["author"],
        featuredMedia: json["featured_media"],
        commentStatus: json["comment_status"],
        pingStatus: json["ping_status"],
        sticky: json["sticky"],
        template: json["template"],
        format: json["format"],
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        categories: json["categories"] == null ? [] : List<int>.from(json["categories"]!.map((x) => x)),
        tags: json["tags"] == null ? [] : List<int>.from(json["tags"]!.map((x) => x)),
        acf: json["acf"] == null ? [] : List<dynamic>.from(json["acf"]!.map((x) => x)),
        links: json["_links"] == null ? null : BlogModelLinks.fromJson(json["_links"]),
        embedded: json["_embedded"] == null ? null : Embedded.fromJson(json["_embedded"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date?.toIso8601String(),
        "date_gmt": dateGmt?.toIso8601String(),
        "guid": guid?.toJson(),
        "modified": modified?.toIso8601String(),
        "modified_gmt": modifiedGmt?.toIso8601String(),
        "slug": slug,
        "status": status,
        "type": type,
        "link": link,
        "title": title?.toJson(),
        "content": content?.toJson(),
        "excerpt": excerpt?.toJson(),
        "author": author,
        "featured_media": featuredMedia,
        "comment_status": commentStatus,
        "ping_status": pingStatus,
        "sticky": sticky,
        "template": template,
        "format": format,
        "meta": meta?.toJson(),
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x)),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "acf": acf == null ? [] : List<dynamic>.from(acf!.map((x) => x)),
        "_links": links?.toJson(),
        "_embedded": embedded?.toJson(),
      };
}

class Content {
  String? rendered;
  bool? protected;

  Content({
    this.rendered,
    this.protected,
  });

  factory Content.fromRawJson(String str) => Content.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        rendered: json["rendered"],
        protected: json["protected"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
        "protected": protected,
      };
}

class Embedded {
  List<EmbeddedAuthor>? author;
  List<EmbeddedAuthor>? replies;
  List<WpFeaturedmedia>? wpFeaturedmedia;
  List<List<EmbeddedWpTerm>>? wpTerm;

  Embedded({
    this.author,
    this.replies,
    this.wpFeaturedmedia,
    this.wpTerm,
  });

  factory Embedded.fromRawJson(String str) => Embedded.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
        author: json["author"] == null ? [] : List<EmbeddedAuthor>.from(json["author"]!.map((x) => EmbeddedAuthor.fromJson(x))),
        replies: json["replies"] == null ? [] : List<EmbeddedAuthor>.from(json["replies"]!.map((x) => EmbeddedAuthor.fromJson(x))),
        wpFeaturedmedia: json["wp:featuredmedia"] == null ? [] : List<WpFeaturedmedia>.from(json["wp:featuredmedia"]!.map((x) => WpFeaturedmedia.fromJson(x))),
        wpTerm: json["wp:term"] == null ? [] : List<List<EmbeddedWpTerm>>.from(json["wp:term"]!.map((x) => List<EmbeddedWpTerm>.from(x.map((x) => EmbeddedWpTerm.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "author": author == null ? [] : List<dynamic>.from(author!.map((x) => x.toJson())),
        "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toJson())),
        "wp:featuredmedia": wpFeaturedmedia == null ? [] : List<dynamic>.from(wpFeaturedmedia!.map((x) => x.toJson())),
        "wp:term": wpTerm == null ? [] : List<dynamic>.from(wpTerm!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}

class EmbeddedAuthor {
  String? code;
  String? message;
  Data? data;

  EmbeddedAuthor({
    this.code,
    this.message,
    this.data,
  });

  factory EmbeddedAuthor.fromRawJson(String str) => EmbeddedAuthor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EmbeddedAuthor.fromJson(Map<String, dynamic> json) => EmbeddedAuthor(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? status;

  Data({
    this.status,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}

class WpFeaturedmedia {
  int? id;
  DateTime? date;
  String? slug;
  String? type;
  String? link;
  Guid? title;
  int? author;
  List<dynamic>? acf;
  Guid? caption;
  String? altText;
  String? mediaType;
  String? mimeType;
  MediaDetails? mediaDetails;
  String? sourceUrl;
  WpFeaturedmediaLinks? links;

  WpFeaturedmedia({
    this.id,
    this.date,
    this.slug,
    this.type,
    this.link,
    this.title,
    this.author,
    this.acf,
    this.caption,
    this.altText,
    this.mediaType,
    this.mimeType,
    this.mediaDetails,
    this.sourceUrl,
    this.links,
  });

  factory WpFeaturedmedia.fromRawJson(String str) => WpFeaturedmedia.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WpFeaturedmedia.fromJson(Map<String, dynamic> json) => WpFeaturedmedia(
        id: json["id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        slug: json["slug"],
        type: json["type"],
        link: json["link"],
        title: json["title"] == null ? null : Guid.fromJson(json["title"]),
        author: json["author"],
        acf: json["acf"] == null ? [] : List<dynamic>.from(json["acf"]!.map((x) => x)),
        caption: json["caption"] == null ? null : Guid.fromJson(json["caption"]),
        altText: json["alt_text"],
        mediaType: json["media_type"],
        mimeType: json["mime_type"],
        mediaDetails: json["media_details"] == null ? null : MediaDetails.fromJson(json["media_details"]),
        sourceUrl: json["source_url"],
        links: json["_links"] == null ? null : WpFeaturedmediaLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date?.toIso8601String(),
        "slug": slug,
        "type": type,
        "link": link,
        "title": title?.toJson(),
        "author": author,
        "acf": acf == null ? [] : List<dynamic>.from(acf!.map((x) => x)),
        "caption": caption?.toJson(),
        "alt_text": altText,
        "media_type": mediaType,
        "mime_type": mimeType,
        "media_details": mediaDetails?.toJson(),
        "source_url": sourceUrl,
        "_links": links?.toJson(),
      };
}

class Guid {
  String? rendered;

  Guid({
    this.rendered,
  });

  factory Guid.fromRawJson(String str) => Guid.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Guid.fromJson(Map<String, dynamic> json) => Guid(
        rendered: json["rendered"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
      };
}

class WpFeaturedmediaLinks {
  List<About>? self;
  List<About>? collection;
  List<About>? about;
  List<WpFeaturedmediaElement>? author;
  List<WpFeaturedmediaElement>? replies;

  WpFeaturedmediaLinks({
    this.self,
    this.collection,
    this.about,
    this.author,
    this.replies,
  });

  factory WpFeaturedmediaLinks.fromRawJson(String str) => WpFeaturedmediaLinks.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WpFeaturedmediaLinks.fromJson(Map<String, dynamic> json) => WpFeaturedmediaLinks(
        self: json["self"] == null ? [] : List<About>.from(json["self"]!.map((x) => About.fromJson(x))),
        collection: json["collection"] == null ? [] : List<About>.from(json["collection"]!.map((x) => About.fromJson(x))),
        about: json["about"] == null ? [] : List<About>.from(json["about"]!.map((x) => About.fromJson(x))),
        author: json["author"] == null ? [] : List<WpFeaturedmediaElement>.from(json["author"]!.map((x) => WpFeaturedmediaElement.fromJson(x))),
        replies: json["replies"] == null ? [] : List<WpFeaturedmediaElement>.from(json["replies"]!.map((x) => WpFeaturedmediaElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null ? [] : List<dynamic>.from(self!.map((x) => x.toJson())),
        "collection": collection == null ? [] : List<dynamic>.from(collection!.map((x) => x.toJson())),
        "about": about == null ? [] : List<dynamic>.from(about!.map((x) => x.toJson())),
        "author": author == null ? [] : List<dynamic>.from(author!.map((x) => x.toJson())),
        "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toJson())),
      };
}

class About {
  String? href;

  About({
    this.href,
  });

  factory About.fromRawJson(String str) => About.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory About.fromJson(Map<String, dynamic> json) => About(
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}

class WpFeaturedmediaElement {
  bool? embeddable;
  String? href;

  WpFeaturedmediaElement({
    this.embeddable,
    this.href,
  });

  factory WpFeaturedmediaElement.fromRawJson(String str) => WpFeaturedmediaElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WpFeaturedmediaElement.fromJson(Map<String, dynamic> json) => WpFeaturedmediaElement(
        embeddable: json["embeddable"],
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "embeddable": embeddable,
        "href": href,
      };
}

class MediaDetails {
  int? width;
  int? height;
  String? file;
  int? filesize;
  Sizes? sizes;
  ImageMeta? imageMeta;

  MediaDetails({
    this.width,
    this.height,
    this.file,
    this.filesize,
    this.sizes,
    this.imageMeta,
  });

  factory MediaDetails.fromRawJson(String str) => MediaDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaDetails.fromJson(Map<String, dynamic> json) => MediaDetails(
        width: json["width"],
        height: json["height"],
        file: json["file"],
        filesize: json["filesize"],
        sizes: json["sizes"] == null ? null : Sizes.fromJson(json["sizes"]),
        imageMeta: json["image_meta"] == null ? null : ImageMeta.fromJson(json["image_meta"]),
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
        "file": file,
        "filesize": filesize,
        "sizes": sizes?.toJson(),
        "image_meta": imageMeta?.toJson(),
      };
}

class ImageMeta {
  String? aperture;
  String? credit;
  String? camera;
  String? caption;
  String? createdTimestamp;
  String? copyright;
  String? focalLength;
  String? iso;
  String? shutterSpeed;
  String? title;
  String? orientation;
  List<dynamic>? keywords;

  ImageMeta({
    this.aperture,
    this.credit,
    this.camera,
    this.caption,
    this.createdTimestamp,
    this.copyright,
    this.focalLength,
    this.iso,
    this.shutterSpeed,
    this.title,
    this.orientation,
    this.keywords,
  });

  factory ImageMeta.fromRawJson(String str) => ImageMeta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImageMeta.fromJson(Map<String, dynamic> json) => ImageMeta(
        aperture: json["aperture"],
        credit: json["credit"],
        camera: json["camera"],
        caption: json["caption"],
        createdTimestamp: json["created_timestamp"],
        copyright: json["copyright"],
        focalLength: json["focal_length"],
        iso: json["iso"],
        shutterSpeed: json["shutter_speed"],
        title: json["title"],
        orientation: json["orientation"],
        keywords: json["keywords"] == null ? [] : List<dynamic>.from(json["keywords"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "aperture": aperture,
        "credit": credit,
        "camera": camera,
        "caption": caption,
        "created_timestamp": createdTimestamp,
        "copyright": copyright,
        "focal_length": focalLength,
        "iso": iso,
        "shutter_speed": shutterSpeed,
        "title": title,
        "orientation": orientation,
        "keywords": keywords == null ? [] : List<dynamic>.from(keywords!.map((x) => x)),
      };
}

class Sizes {
  Full? medium;
  Full? large;
  Full? thumbnail;
  Full? mediumLarge;
  Full? wpRigFeatured;
  Full? full;

  Sizes({
    this.medium,
    this.large,
    this.thumbnail,
    this.mediumLarge,
    this.wpRigFeatured,
    this.full,
  });

  factory Sizes.fromRawJson(String str) => Sizes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sizes.fromJson(Map<String, dynamic> json) => Sizes(
        medium: json["medium"] == null ? null : Full.fromJson(json["medium"]),
        large: json["large"] == null ? null : Full.fromJson(json["large"]),
        thumbnail: json["thumbnail"] == null ? null : Full.fromJson(json["thumbnail"]),
        mediumLarge: json["medium_large"] == null ? null : Full.fromJson(json["medium_large"]),
        wpRigFeatured: json["wp-rig-featured"] == null ? null : Full.fromJson(json["wp-rig-featured"]),
        full: json["full"] == null ? null : Full.fromJson(json["full"]),
      );

  Map<String, dynamic> toJson() => {
        "medium": medium?.toJson(),
        "large": large?.toJson(),
        "thumbnail": thumbnail?.toJson(),
        "medium_large": mediumLarge?.toJson(),
        "wp-rig-featured": wpRigFeatured?.toJson(),
        "full": full?.toJson(),
      };
}

class Full {
  String? file;
  int? width;
  int? height;
  String? mimeType;
  String? sourceUrl;
  int? filesize;

  Full({
    this.file,
    this.width,
    this.height,
    this.mimeType,
    this.sourceUrl,
    this.filesize,
  });

  factory Full.fromRawJson(String str) => Full.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Full.fromJson(Map<String, dynamic> json) => Full(
        file: json["file"],
        width: json["width"],
        height: json["height"],
        mimeType: json["mime_type"],
        sourceUrl: json["source_url"],
        filesize: json["filesize"],
      );

  Map<String, dynamic> toJson() => {
        "file": file,
        "width": width,
        "height": height,
        "mime_type": mimeType,
        "source_url": sourceUrl,
        "filesize": filesize,
      };
}

class EmbeddedWpTerm {
  int? id;
  String? link;
  String? name;
  String? slug;
  String? taxonomy;
  List<dynamic>? acf;
  WpTermLinks? links;

  EmbeddedWpTerm({
    this.id,
    this.link,
    this.name,
    this.slug,
    this.taxonomy,
    this.acf,
    this.links,
  });

  factory EmbeddedWpTerm.fromRawJson(String str) => EmbeddedWpTerm.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EmbeddedWpTerm.fromJson(Map<String, dynamic> json) => EmbeddedWpTerm(
        id: json["id"],
        link: json["link"],
        name: json["name"],
        slug: json["slug"],
        taxonomy: json["taxonomy"],
        acf: json["acf"] == null ? [] : List<dynamic>.from(json["acf"]!.map((x) => x)),
        links: json["_links"] == null ? null : WpTermLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "link": link,
        "name": name,
        "slug": slug,
        "taxonomy": taxonomy,
        "acf": acf == null ? [] : List<dynamic>.from(acf!.map((x) => x)),
        "_links": links?.toJson(),
      };
}

class WpTermLinks {
  List<About>? self;
  List<About>? collection;
  List<About>? about;
  List<About>? wpPostType;
  List<Cury>? curies;

  WpTermLinks({
    this.self,
    this.collection,
    this.about,
    this.wpPostType,
    this.curies,
  });

  factory WpTermLinks.fromRawJson(String str) => WpTermLinks.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WpTermLinks.fromJson(Map<String, dynamic> json) => WpTermLinks(
        self: json["self"] == null ? [] : List<About>.from(json["self"]!.map((x) => About.fromJson(x))),
        collection: json["collection"] == null ? [] : List<About>.from(json["collection"]!.map((x) => About.fromJson(x))),
        about: json["about"] == null ? [] : List<About>.from(json["about"]!.map((x) => About.fromJson(x))),
        wpPostType: json["wp:post_type"] == null ? [] : List<About>.from(json["wp:post_type"]!.map((x) => About.fromJson(x))),
        curies: json["curies"] == null ? [] : List<Cury>.from(json["curies"]!.map((x) => Cury.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null ? [] : List<dynamic>.from(self!.map((x) => x.toJson())),
        "collection": collection == null ? [] : List<dynamic>.from(collection!.map((x) => x.toJson())),
        "about": about == null ? [] : List<dynamic>.from(about!.map((x) => x.toJson())),
        "wp:post_type": wpPostType == null ? [] : List<dynamic>.from(wpPostType!.map((x) => x.toJson())),
        "curies": curies == null ? [] : List<dynamic>.from(curies!.map((x) => x.toJson())),
      };
}

class Cury {
  String? name;
  String? href;
  bool? templated;

  Cury({
    this.name,
    this.href,
    this.templated,
  });

  factory Cury.fromRawJson(String str) => Cury.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cury.fromJson(Map<String, dynamic> json) => Cury(
        name: json["name"],
        href: json["href"],
        templated: json["templated"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "href": href,
        "templated": templated,
      };
}

class BlogModelLinks {
  List<About>? self;
  List<About>? collection;
  List<About>? about;
  List<WpFeaturedmediaElement>? author;
  List<WpFeaturedmediaElement>? replies;
  List<VersionHistory>? versionHistory;
  List<PredecessorVersion>? predecessorVersion;
  List<WpFeaturedmediaElement>? wpFeaturedmedia;
  List<About>? wpAttachment;
  List<LinksWpTerm>? wpTerm;
  List<Cury>? curies;

  BlogModelLinks({
    this.self,
    this.collection,
    this.about,
    this.author,
    this.replies,
    this.versionHistory,
    this.predecessorVersion,
    this.wpFeaturedmedia,
    this.wpAttachment,
    this.wpTerm,
    this.curies,
  });

  factory BlogModelLinks.fromRawJson(String str) => BlogModelLinks.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlogModelLinks.fromJson(Map<String, dynamic> json) => BlogModelLinks(
        self: json["self"] == null ? [] : List<About>.from(json["self"]!.map((x) => About.fromJson(x))),
        collection: json["collection"] == null ? [] : List<About>.from(json["collection"]!.map((x) => About.fromJson(x))),
        about: json["about"] == null ? [] : List<About>.from(json["about"]!.map((x) => About.fromJson(x))),
        author: json["author"] == null ? [] : List<WpFeaturedmediaElement>.from(json["author"]!.map((x) => WpFeaturedmediaElement.fromJson(x))),
        replies: json["replies"] == null ? [] : List<WpFeaturedmediaElement>.from(json["replies"]!.map((x) => WpFeaturedmediaElement.fromJson(x))),
        versionHistory: json["version-history"] == null ? [] : List<VersionHistory>.from(json["version-history"]!.map((x) => VersionHistory.fromJson(x))),
        predecessorVersion: json["predecessor-version"] == null ? [] : List<PredecessorVersion>.from(json["predecessor-version"]!.map((x) => PredecessorVersion.fromJson(x))),
        wpFeaturedmedia: json["wp:featuredmedia"] == null ? [] : List<WpFeaturedmediaElement>.from(json["wp:featuredmedia"]!.map((x) => WpFeaturedmediaElement.fromJson(x))),
        wpAttachment: json["wp:attachment"] == null ? [] : List<About>.from(json["wp:attachment"]!.map((x) => About.fromJson(x))),
        wpTerm: json["wp:term"] == null ? [] : List<LinksWpTerm>.from(json["wp:term"]!.map((x) => LinksWpTerm.fromJson(x))),
        curies: json["curies"] == null ? [] : List<Cury>.from(json["curies"]!.map((x) => Cury.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null ? [] : List<dynamic>.from(self!.map((x) => x.toJson())),
        "collection": collection == null ? [] : List<dynamic>.from(collection!.map((x) => x.toJson())),
        "about": about == null ? [] : List<dynamic>.from(about!.map((x) => x.toJson())),
        "author": author == null ? [] : List<dynamic>.from(author!.map((x) => x.toJson())),
        "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toJson())),
        "version-history": versionHistory == null ? [] : List<dynamic>.from(versionHistory!.map((x) => x.toJson())),
        "predecessor-version": predecessorVersion == null ? [] : List<dynamic>.from(predecessorVersion!.map((x) => x.toJson())),
        "wp:featuredmedia": wpFeaturedmedia == null ? [] : List<dynamic>.from(wpFeaturedmedia!.map((x) => x.toJson())),
        "wp:attachment": wpAttachment == null ? [] : List<dynamic>.from(wpAttachment!.map((x) => x.toJson())),
        "wp:term": wpTerm == null ? [] : List<dynamic>.from(wpTerm!.map((x) => x.toJson())),
        "curies": curies == null ? [] : List<dynamic>.from(curies!.map((x) => x.toJson())),
      };
}

class PredecessorVersion {
  int? id;
  String? href;

  PredecessorVersion({
    this.id,
    this.href,
  });

  factory PredecessorVersion.fromRawJson(String str) => PredecessorVersion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PredecessorVersion.fromJson(Map<String, dynamic> json) => PredecessorVersion(
        id: json["id"],
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "href": href,
      };
}

class VersionHistory {
  int? count;
  String? href;

  VersionHistory({
    this.count,
    this.href,
  });

  factory VersionHistory.fromRawJson(String str) => VersionHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VersionHistory.fromJson(Map<String, dynamic> json) => VersionHistory(
        count: json["count"],
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "href": href,
      };
}

class LinksWpTerm {
  String? taxonomy;
  bool? embeddable;
  String? href;

  LinksWpTerm({
    this.taxonomy,
    this.embeddable,
    this.href,
  });

  factory LinksWpTerm.fromRawJson(String str) => LinksWpTerm.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LinksWpTerm.fromJson(Map<String, dynamic> json) => LinksWpTerm(
        taxonomy: json["taxonomy"],
        embeddable: json["embeddable"],
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "taxonomy": taxonomy,
        "embeddable": embeddable,
        "href": href,
      };
}

class Meta {
  String? footnotes;

  Meta({
    this.footnotes,
  });

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        footnotes: json["footnotes"],
      );

  Map<String, dynamic> toJson() => {
        "footnotes": footnotes,
      };
}
