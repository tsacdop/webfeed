import 'dart:core';

import 'package:webfeed/domain/dublin_core/dublin_core.dart';
import 'package:webfeed/domain/podcast_funding.dart';
import 'package:webfeed/domain/podcast_location.dart';
import 'package:webfeed/domain/podcast_lock.dart';
import 'package:webfeed/domain/rss_category.dart';
import 'package:webfeed/domain/rss_cloud.dart';
import 'package:webfeed/domain/rss_image.dart';
import 'package:webfeed/domain/rss_item.dart';
import 'package:webfeed/util/helpers.dart';
import 'package:xml/xml.dart';

import '../util/helpers.dart';
import 'podcast_person.dart';
import 'rss_itunes.dart';

class RssFeed {
  final String? title;
  final String? author;
  final String? description;
  final String? link;
  final List<RssItem>? items;

  final RssImage? image;
  final RssCloud? cloud;
  final List<RssCategory>? categories;
  final List<String>? skipDays;
  final List<int>? skipHours;
  final String? lastBuildDate;
  final String? language;
  final String? generator;
  final String? copyright;
  final String? docs;
  final String? managingEditor;
  final String? rating;
  final String? webMaster;
  final int? ttl;
  final DublinCore? dc;
  final RssItunes? itunes;
  final List<PodcastFunding?>? podcastFunding;
  final PodcastLocked? podcastLocked;
  final List<PodcastPerson?>? podcastPerson;
  final PodcastLocation? podcastLocation;

  RssFeed(
      {this.title,
      this.author,
      this.description,
      this.link,
      this.items,
      this.image,
      this.cloud,
      this.categories,
      this.skipDays,
      this.skipHours,
      this.lastBuildDate,
      this.language,
      this.generator,
      this.copyright,
      this.docs,
      this.managingEditor,
      this.rating,
      this.webMaster,
      this.ttl,
      this.dc,
      this.itunes,
      this.podcastFunding,
      this.podcastLocked,
      this.podcastPerson,
      this.podcastLocation});

  factory RssFeed.parse(String xmlString) {
    var document = XmlDocument.parse(xmlString);
    XmlElement channelElement;
    try {
      channelElement = document.findAllElements("channel").first;
    } on StateError {
      throw ArgumentError("channel not found");
    }

    return RssFeed(
        title: findElementOrNull(channelElement, "title")?.text.trim(),
        author: findElementOrNull(channelElement, "author")?.text.trim(),
        description:
            findElementOrNull(channelElement, "description")?.text.trim(),
        link: findElementOrNull(channelElement, "link")?.text.trim(),
        items: channelElement.findElements("item").map((element) {
          return RssItem.parse(element);
        }).toList(),
        image: RssImage.parse(findElementOrNull(channelElement, "image")),
        //cloud: RssCloud.parse(findElementOrNull(channelElement, "cloud")),
        //categories: channelElement.findElements("category").map((element) {
        //  return RssCategory.parse(element);
        //}).toList(),
        // skipDays: findElementOrNull(channelElement, "skipDays")
        //         ?.findAllElements("day")
        //         ?.map((element) {
        //       return element.text;
        //     })?.toList() ??
        //     [],
        // skipHours: findElementOrNull(channelElement, "skipHours")
        //         ?.findAllElements("hour")
        //         ?.map((element) {
        //       return int.tryParse(element.text ?? "0");
        //     })?.toList() ??
        //     [],
        // lastBuildDate: findElementOrNull(channelElement, "lastBuildDate")?.text,
        language: findElementOrNull(channelElement, "language")?.text,
        generator: findElementOrNull(channelElement, "generator")?.text,
        // copyright: findElementOrNull(channelElement, "copyright")?.text,
        // docs: findElementOrNull(channelElement, "docs")?.text,
        // managingEditor: findElementOrNull(channelElement, "managingEditor")?.text,
        // rating: findElementOrNull(channelElement, "rating")?.text,
        // webMaster: findElementOrNull(channelElement, "webMaster")?.text,
        // ttl: int.tryParse(findElementOrNull(channelElement, "ttl")?.text ?? "0"),
        dc: DublinCore.parse(channelElement),
        itunes: RssItunes.parse(channelElement),
        podcastFunding:
            findAllDirectElementsOrNull(channelElement, "podcast:funding")!
                .map((element) => PodcastFunding.parse(element))
                .toList(),
        podcastLocked: PodcastLocked.parse(
            findElementOrNull(channelElement, "podcast:locked")),
        podcastPerson:
            findAllDirectElementsOrNull(channelElement, "podcast:person")!
                .map((element) => PodcastPerson.parse(element))
                .toList(),
        podcastLocation: PodcastLocation.parse(
            findElementOrNull(channelElement, "podcast:location")));
  }
}
